package br.com.cjm.mega.business.test;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import junit.framework.TestCase;
import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;
import br.com.cjm.mega.business.impl.FrequenciaServiceImpl;
import br.com.cjm.mega.business.impl.ResultadosHtmlParseServiceImpl;
import br.com.cjm.mega.datatype.FrequenciaDuplasTO;

public class ResultadosHtmlParseServiceTest extends TestCase {

	public void testCarregarFrequencias() {

		FrequenciaServiceImpl service = new FrequenciaServiceImpl();
		// service.processarFrequencias();
		Map<Integer, FrequenciaDuplasTO> frequencias = service
				.criarFrequenciaDuplas(false);
		service.processarFrequenciaDuplas(null, frequencias);
	}

	public void testImportarResultadosHtml() {

		ResultadosHtmlParseServiceImpl service = new ResultadosHtmlParseServiceImpl();
		service
				.importarResultadosHtml("C:/Documents and Settings/Cristiano/Desktop/D_MEGA2.HTM");

	}

	public void testSerializeble() {

		List<String> strList = new ArrayList<String>();
		strList.add("A");
		strList.add("B");
		strList.add("C");

		String serial = objToString(strList);
		System.out.println(serial);

		List<String> deserial = (List<String>) stringToObject(serial);

	}

	public String objToString(Object obj) {
		String out = null;
		if (obj != null) {
			BASE64Encoder encode = new BASE64Encoder();
			try {
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				ObjectOutputStream oos = new ObjectOutputStream(baos);
				oos.writeObject(obj);
				out = encode.encode(baos.toByteArray());
			} catch (IOException e) {
				e.printStackTrace();
				return null;
			}
		}
		return out;
	}

	public Object stringToObject(String str) {
		long start = System.currentTimeMillis();
		Object out = null;
		if (str != null) {
			BASE64Decoder decode = new BASE64Decoder();
			try {

				ByteArrayInputStream bios = new ByteArrayInputStream(decode
						.decodeBuffer(str));
				ObjectInputStream ois = new ObjectInputStream(bios);
				out = ois.readObject();
			} catch (IOException e) {
				e.printStackTrace();
				return null;
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
				return null;
			}
		}
		long end = System.currentTimeMillis();
		System.out.println("Decode:" + (end - start));
		return out;
	}

}
