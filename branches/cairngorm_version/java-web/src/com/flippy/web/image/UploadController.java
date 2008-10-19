package com.flippy.web.image;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

/**
 * @author uudashr
 *
 */
public class UploadController implements Controller {
    private static final Log logger = LogFactory.getLog(UploadController.class);
    
    private File storageDir;
    
    public void setStorageDir(File storageDir) {
        this.storageDir = storageDir;
    }
    
    @Override
    public ModelAndView handleRequest(HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
        String sessionId = multipartRequest.getParameter("sessionId");
        MultipartFile file = multipartRequest.getFile("imageFile");
        logger.info("Uploading file '" + file.getOriginalFilename() + "' for session '" + sessionId + "'");
        
        File sessionStorageDir = new File(storageDir, "ses_" + sessionId);
        if (!sessionStorageDir.exists()) {
            logger.info("Storage directory  '" + sessionStorageDir + "' not yet exist. Creating this directory");
            boolean succeed = sessionStorageDir.mkdirs();
            if (!succeed) {
                logger.error("Creating storage directory '" + sessionStorageDir + "' failed");
            } else {
                logger.info("Succeed creating storage directory '" + sessionStorageDir + "'");
            }
        }
        
        logger.debug("Prepare file writing...");
        BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(new File(sessionStorageDir, file.getOriginalFilename())));
        InputStream in = file.getInputStream();
        byte[] b = new byte[1024];
        int readed;
        logger.info("Writing the uploaded file '" + file.getOriginalFilename() + "' ...");
        while ((readed = in.read(b)) > -1) {
            bos.write(b, 0, readed);
        }
        bos.flush();
        bos.close();
        logger.info("Done writing file " + file.getOriginalFilename());
        logger.info("Upload completed");
        logger.info("Curr dir = " + new File(".").getAbsolutePath());
        return null;
    }
    
}
