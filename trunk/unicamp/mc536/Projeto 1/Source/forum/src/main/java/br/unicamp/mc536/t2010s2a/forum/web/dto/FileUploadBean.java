package br.unicamp.mc536.t2010s2a.forum.web.dto;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

public class FileUploadBean {

	/*private byte[] file;

	public void setFile(byte[] file) {
		this.file = file;
	}

	public byte[] getFile() {
		return file;
	}*/
	
	private CommonsMultipartFile file;

	/**
	 * @return the file
	 */
	public CommonsMultipartFile getFile() {
		return file;
	}

	/**
	 * @param file the file to set
	 */
	public void setFile(CommonsMultipartFile file) {
		this.file = file;
	}
	
	
}
