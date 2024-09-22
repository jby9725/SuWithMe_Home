package com.example.demo.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.vo.Event;

@Mapper
public interface CalenderRepository {

	@Select("""
			SELECT *
			FROM `event`
			WHERE memberId = #{memberId};
			""")
	public List<Event> getAllEventsBymemberId(int memberId);

	@Insert("""
			INSERT INTO `event`
			SET title = #{title},
			`body` = #{body},
			createDate = NOW(),
			updateDate = NOW(),
			startDate = #{startDate},
			endDate = #{endDate},
			memberId = #{memberId};
			""")
	public void addEvent(String title, String body, String startDate, String endDate, int memberId);

	@Delete("""
			DELETE FROM `event`
			WHERE id = #{id};
			""")
	public void deleteEvent(int id);

	@Update("""
			UPDATE `event`
			SET updateDate = NOW(),
			title = #{title},
			`body` = #{body}
			WHERE id = #{id};
			""")
	public void modifyEvent(int id, String title, String body);

	// 이벤트 ID로 이벤트 조회
	@Select("""
			SELECT E.*, M.nickname AS nickname
			FROM `event` E
			INNER JOIN `member` M
			ON M.id = E.memberId
			WHERE E.id = #{eventId};
			""")
	public Event getEventById(int eventId);

	// 이벤트의 completed 상태를 업데이트
	@Update("""
			    UPDATE `event`
			    SET completed = #{completed},
			    updateDate = NOW()
			    WHERE id = #{eventId};
			""")
	public void updateCompletedStatus(int eventId, boolean completed);

	@Select("""
			SELECT COUNT(*)
			FROM `event`
			WHERE memberId = #{memberId}
			AND completed = TRUE;
			""")
	public int countCompletedEventsByMemberId(int memberId);

	// 완료된 일정 개수로 오수완 왕을 찾는 쿼리
	@Select("""
			SELECT M.nickname, COUNT(E.id) as completedCount
			FROM `event` E
			INNER JOIN `member` M ON E.memberId = M.id
			WHERE E.completed = TRUE
			GROUP BY E.memberId
			ORDER BY completedCount DESC
			LIMIT 1;
			""")
	public Map<String, Object> getTopCompletedMember();
}