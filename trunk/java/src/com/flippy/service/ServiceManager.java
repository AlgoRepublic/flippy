package com.flippy.service;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class ServiceManager {
	private ApplicationContext aCtx = null;
	private static ServiceManager mgr = null;
	
	protected ExecutorService pool = null;
	
	private ServiceManager(String conf) {
		aCtx = new ClassPathXmlApplicationContext(conf);
		pool = Executors.newCachedThreadPool(); 
	}
	
	public static ServiceManager getInstance() {
		if (mgr != null) {
			return mgr;
		} else {
			return mgr = new ServiceManager("beans.xml");
		}
	}
	
	public ApplicationContext getContext() {
		return aCtx;
	}
	
	public void execute(Runnable r) {
		pool.execute(r);
	}
}
 