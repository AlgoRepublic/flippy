package com.flippy.wowza;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.wowza.wms.application.IApplicationInstance;
import com.wowza.wms.module.ModuleBase;


public class FlippyModuleBase extends ModuleBase {
	
	private static ApplicationContext aCtx;
	
	public static ApplicationContext getApplicationContext() {
		if (aCtx != null) {
			return aCtx;
		} else {
			aCtx = new ClassPathXmlApplicationContext("beans.xml");
			
			return aCtx;
		}
	}
	
	public void onAppStart(IApplicationInstance appInstance) {
		getApplicationContext();
	}
	
	
}
