package com.flippy.web.image;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

/**
 * @author uudashr
 *
 */
public class ImageController implements Controller {
    private static final Log logger = LogFactory.getLog(ImageController.class);
    
    private File storageDir;
    
    public void setStorageDir(File storageDir) {
        this.storageDir = storageDir;
    }
    
    @Override
    public ModelAndView handleRequest(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        String sessionId = request.getParameter("sessionId");
        String image = request.getParameter("image");
        //http://localhost:8080/Flimage/image.htm?sessionId=10&image=10-02-08ballmer.jpg
        
        File file = new File(storageDir.getAbsoluteFile() + "/ses_" + sessionId, image);
        
        logger.info("Locating image '" + file + "'");
        
        response.setContentLength((int)file.length());
        
        FileInputStream in = null;
        OutputStream out = null;
        try {
            in = new FileInputStream(file);
            out = response.getOutputStream();
            byte[] buf = new byte[1024];
            int readed;
            while ((readed = in.read(buf)) > -1) {
                out.write(buf, 0, readed);
            }
            out.flush();
        } catch (IOException e) {
            
        } finally {
            if (in != null) {
                try { in.close(); } catch (IOException e) {}
            }
            if (out != null) {
                try { out.close(); } catch (IOException e) {}
            }
        }
        return null;
    }
}
