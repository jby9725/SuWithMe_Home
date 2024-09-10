package com.example.demo.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartRequest;

import com.example.demo.service.ArticleService;
import com.example.demo.service.BoardService;
import com.example.demo.service.ReplyService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Article;
import com.example.demo.vo.Board;
import com.example.demo.vo.Reply;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrArticleController {

	@Autowired
	private Rq rq;

	@Autowired
	private ArticleService articleService;

	@Autowired
	private BoardService boardService;

	@Autowired
	private ReplyService replyService;

// 서비스 메서드 (내부에서 동작)
	//

// 액션 메서드 (외부와 통신)
	@RequestMapping("/usr/article/write")
	public String writeArticle(Model model) {

		int currentId = articleService.getCurrentArticleId();

		model.addAttribute("currentId", currentId);

		return "/usr/article/write";
	}

	@RequestMapping("/usr/article/list")
	public String showList(HttpServletRequest req, Model model, @RequestParam(defaultValue = "1") int boardId,
			@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "title,body") String searchKeywordTypeCode,
			@RequestParam(defaultValue = "") String searchKeyword) throws IOException {

		Rq rq = (Rq) req.getAttribute("rq");

		Board board = boardService.getBoardById(boardId);

		if (board == null) {
			return rq.historyBackOnView("없는 게시판임");
		}

		int articlesCount = articleService.getArticlesCount(boardId, searchKeywordTypeCode, searchKeyword);

		// 한페이지에 글 10개
		// 글 20개 -> 2page
		// 글 25개 -> 3page
		int itemsInAPage = 10;

		int pagesCount = (int) Math.ceil(articlesCount / (double) itemsInAPage);

		List<Article> articles = articleService.getForPrintArticles(boardId, itemsInAPage, page, searchKeywordTypeCode,
				searchKeyword);

		model.addAttribute("articles", articles);
		model.addAttribute("articlesCount", articlesCount);
		model.addAttribute("pagesCount", pagesCount);
		model.addAttribute("board", board);
		model.addAttribute("page", page);
		model.addAttribute("searchKeywordTypeCode", searchKeywordTypeCode);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("boardId", boardId);

		return "usr/article/list";
	}

	@RequestMapping("/usr/article/detail")
	public String showDetail(HttpServletRequest req, Model model, int id) {
		Rq rq = (Rq) req.getAttribute("rq");

		Article article = articleService.getForPrintArticle(rq.getLoginedMemberId(), id);

		List<Reply> replies = replyService.getForPrintReplies(rq.getLoginedMemberId(), "article", id);

		int repliesCount = replies.size();

		model.addAttribute("article", article);

		model.addAttribute("replies", replies);
		model.addAttribute("repliesCount", repliesCount);

		return "usr/article/detail";
	}

	@RequestMapping("/usr/article/doIncreaseHitCountRd")
	@ResponseBody
	public ResultData doIncreaseHitCount(int id) {

		ResultData increaseHitCountRd = articleService.increaseHitCount(id);

		if (increaseHitCountRd.isFail()) {
			return increaseHitCountRd;
		}

		ResultData rd = ResultData.newData(increaseHitCountRd, "hitCount", articleService.getArticleHitCount(id));

		rd.setData2("조회수가 증가된 게시글의 id", id);

		return rd;
	}

	@RequestMapping("/usr/article/modify")
	public String articleModify(HttpServletRequest req, Model model, int id) {

		Rq rq = (Rq) req.getAttribute("rq");

		Article article = articleService.getForPrintArticle(rq.getLoginedMemberId(), id);

		if (article == null) {
			return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없습니다", id));
		}

		model.addAttribute("article", article);

		return "/usr/article/modify";
	}

	@RequestMapping("/usr/article/doWrite")
	@ResponseBody
	public String doWrite(HttpServletRequest req, String boardId, String title, String body, String replaceUri,
			MultipartRequest multipartRequest) {
		Rq rq = (Rq) req.getAttribute("rq");

		if (Ut.isEmptyOrNull(title)) {
			return Ut.jsHistoryBack("F-1", "제목을 입력해주세요");
		}
		if (Ut.isEmptyOrNull(body)) {
			return Ut.jsHistoryBack("F-2", "내용을 입력해주세요");
		}
		if (Ut.isEmptyOrNull(boardId)) {
			return Ut.jsHistoryBack("F-3", "게시판을 선택해주세요");
		}

		System.err.println(boardId);

		ResultData writeArticleRd = articleService.writeArticle(rq.getLoginedMemberId(), title, body, boardId);

		// 위 rd가 올바르게 생성이 되었다면 data1 부분에 id값이 들어가있다.
		int id = (int) writeArticleRd.getData1();

		Article article = articleService.getArticleById(id);

		return Ut.jsReplace(writeArticleRd.getResultCode(), writeArticleRd.getMsg(), "../article/detail?id=" + id);
	}

	// 로그인 체크 -> 유무 체크 -> 권한 체크 -> 삭제
	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	public String doDelete(HttpServletRequest req, int id) {

		Rq rq = (Rq) req.getAttribute("rq");

		// 유무 체크
		Article article = articleService.getArticleById(id);

		if (article == null) {
//			return id + "번 글이 없어 삭제되지 않았습니다.";
			return Ut.jsHistoryBack("F-1", Ut.f("%d번 글이 없어 삭제되지 않았습니다.", id));
		}

		// 권한 체크
		ResultData userCanDeleteRd = articleService.userCanDelete(rq.getLoginedMemberId(), article);

		if (userCanDeleteRd.isFail()) {
			return Ut.jsHistoryBack(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg());
		}

		if (userCanDeleteRd.isSuccess()) {
			articleService.deleteArticle(id);
		}

		return Ut.jsReplace(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg(), "../article/list");

	} // /usr/article/doDelete?id=1

	// 로그인 체크 -> 유무 체크 -> 권한 체크 -> 수정
	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public String doModify(HttpServletRequest req, int id, String title, String body) {

		Rq rq = (Rq) req.getAttribute("rq");

		// 수정되기 전 게시글
		Article article = articleService.getArticleById(id);

		// 게시글 유무 체크
		if (article == null) {
//			return ResultData.from("F-1", Ut.f("%d번 글을 찾을 수 없어 수정되지 않았습니다.", id));
			return Ut.jsHistoryBack("F-1", Ut.f("%d번 글을 찾을 수 없어 수정되지 않았습니다.", id));
		}

		// 권한 체크
		ResultData userCanModifyRd = articleService.userCanModify(rq.getLoginedMemberId(), article);

		if (userCanModifyRd.isFail()) {
			return Ut.jsHistoryBack("F-2", Ut.f("%d번 글을 수정할 권한이 없습니다.", id));
//			return userCanModifyRd;
		}

		// 수정
		if (userCanModifyRd.isSuccess()) {
			articleService.modifyArticle(id, title, body);
		}

		// 수정된 게시글 다시 불러옴
		article = articleService.getArticleById(id);

//		return ResultData.from(userCanModifyRd.getResultCode(), userCanModifyRd.getMsg(), "수정 된 게시글", article);
//		return Ut.jsHistoryBack("S-1", Ut.f("%d번 글을 수정하였습니다.", id));
		return Ut.jsReplace(userCanModifyRd.getResultCode(), userCanModifyRd.getMsg(), "../article/list");
	} // /usr/article/doModify?id=1&title=새_제목&body=새_내용
}
