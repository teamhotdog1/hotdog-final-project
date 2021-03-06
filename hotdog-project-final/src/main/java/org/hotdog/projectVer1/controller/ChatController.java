package org.hotdog.projectVer1.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.hotdog.projectVer1.model.ChatService;
import org.hotdog.projectVer1.model.ChatVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

@Controller
public class ChatController {
	
	@Resource
	ChatService chatService;
	
	@ResponseBody
	@RequestMapping("insertChat.do")
	public void insertChat(ChatVO chatVO, HttpServletResponse response) throws IOException, InterruptedException{
		chatService.insertChat(chatVO);
	}
	
	@RequestMapping("getNewMessages.do")
	public void getNewMessages(HttpServletResponse response) throws IOException, InterruptedException{
        int lastChatId = chatService.getLastChatId();
        while (true) {
            List<ChatVO> newChatList = chatService.readById(lastChatId);
            if (newChatList.size() > 0) {
                lastChatId = newChatList.get(newChatList.size() - 1).getChatId();
                response.setContentType("text/event-stream;charset=UTF-8");
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Expires", 0);
                PrintWriter writer = response.getWriter();
                writer.write("event: message\n\n");
                writer.write("data: " + new Gson().toJson(newChatList) + "\n\n");
                writer.flush();
            }
            Thread.sleep(300);
        }
	}
	
	@ResponseBody
	@RequestMapping("getChatList.do")
	public List<ChatVO> getChatList(String loginTime){
		return chatService.getChatList(loginTime);
	}
}