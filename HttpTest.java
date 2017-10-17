package com.quarkioe.bsp.service.provider.socket;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import net.sf.json.JSONObject;

public class HttpTest {
	public static void main(String[]args){
		//创建电子围栏
		try {
			URL url = new URL("http://restapi.amap.com/v4/geofence/meta?key=e32c22ad1a13d90e5c211db46113383e");
			HttpURLConnection connection = (HttpURLConnection)url.openConnection();
			connection.setDoInput(true);
	        connection.setDoOutput(true);
	        connection.setRequestMethod("POST");
	        connection.setUseCaches(false);
            connection.setInstanceFollowRedirects(true);
            connection.setRequestProperty("Content-Type","application/json");
            connection.connect();
            DataOutputStream out = new DataOutputStream(connection.getOutputStream());
            JSONObject obj = new JSONObject();
            obj.put("name","11111");
            obj.put("center", "115.672126,38.817129");
            obj.put("radius", "1000");
            obj.put("enable", "true");
            obj.put("valid_time", "2017-07-26");
            obj.put("repeat", "Mon,Tues,Wed,Thur,Fri,Sat,Sun");
            obj.put("time", "00:00,11:59;13:00,20:59");
            obj.put("desc", "测试围栏描述");
            obj.put("alert_condition", "enter;leave");
            String query = obj.toString();
            out.writeBytes(query);
            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String lines;
            StringBuffer sbf = new StringBuffer();
            while ((lines = reader.readLine()) != null) {
                lines = new String(lines.getBytes(), "utf-8");
                sbf.append(lines);
            }
            System.out.println(sbf);
            
            //获取gid
            JSONObject fromObject = JSONObject.fromObject(sbf.toString());
            JSONObject opt = (JSONObject)fromObject.opt("data");
            String gid = opt.opt("gid").toString();
            System.out.println(gid);
            
            reader.close();
            connection.disconnect();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		
		
		
		//删除电子围栏
		/*try {
		URL url = new URL("http://restapi.amap.com/v4/geofence/meta?key=e32c22ad1a13d90e5c211db46113383e&gid=6289c322-d9fd-47a0-a2bd-bd8cdbe34a2e");
		
		HttpURLConnection connection = (HttpURLConnection)url.openConnection();
		connection.setDoInput(true);
        connection.setDoOutput(true);
        connection.setRequestMethod("DELETE");
        connection.setUseCaches(false);
        connection.setInstanceFollowRedirects(true);
        connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
        connection.connect();
        DataOutputStream out = new DataOutputStream(connection.getOutputStream());
        
        BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
        String lines;
        StringBuffer sbf = new StringBuffer();
        while ((lines = reader.readLine()) != null) {
            lines = new String(lines.getBytes(), "utf-8");
            sbf.append(lines);
        }
        System.out.println(sbf);
        
        
        reader.close();
        connection.disconnect();
		} catch (Exception e) {
			e.printStackTrace();
		}*/
		
		
		//查询电子围栏
		/*try {
			StringBuffer sb = new StringBuffer();
			URL url = new URL("http://restapi.amap.com/v4/geofence/meta?key=e32c22ad1a13d90e5c211db46113383e");
			URLConnection urlConnection = url.openConnection();
			urlConnection.setAllowUserInteraction(false);
			InputStreamReader isr = new InputStreamReader(url.openStream());
			BufferedReader br = new BufferedReader(isr);
			String line;
			while ((line = br.readLine()) != null)
		    {
				sb.append(line);
		    }
			System.out.println(sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}*/
		
		
		//修改电子围栏
		/*try {
			 HttpClient client = new DefaultHttpClient();
			 HttpPatch httpPatch = new HttpPatch("http://restapi.amap.com/v4/geofence/meta?key=e32c22ad1a13d90e5c211db46113383e&gid=6289c322-d9fd-47a0-a2bd-bd8cdbe34a2e");
			 httpPatch.setHeader("Content-Type", "application/json");
			 JSONObject obj = new JSONObject();
			 obj.put("name","11111");
	         obj.put("center", "114.672126,38.817129");
	         String query = obj.toString();
	         StringEntity s = new StringEntity(query, "utf-8");
	         s.setContentEncoding(new BasicHeader(HTTP.CONTENT_TYPE,"application/json"));
	         httpPatch.setEntity(s);
	         HttpResponse response = client.execute(httpPatch);
	         InputStream inStream = response.getEntity().getContent();
	         BufferedReader reader = new BufferedReader(new InputStreamReader(inStream, "utf-8"));
	         StringBuilder strber = new StringBuilder();
	         String line = null;
	         while ((line = reader.readLine()) != null)
        	 {
	        	 strber.append(line + "\n");
        	 }
	         inStream.close();
	         String result = strber.toString();
	         System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}*/
		
		
		//围栏设备监控
		/*try {
			StringBuffer sb = new StringBuffer();
			URL url = new URL("http://restapi.amap.com/v4/geofence/status?key=e32c22ad1a13d90e5c211db46113383e&locations=115.672126,38.817129,1484816232&diu=358568072860640");
			URLConnection urlConnection = url.openConnection();
			urlConnection.setAllowUserInteraction(false);
			InputStreamReader isr = new InputStreamReader(url.openStream());
			BufferedReader br = new BufferedReader(isr);
			String line;
			while ((line = br.readLine()) != null)
		    {
				sb.append(line);
		    }
			System.out.println(sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}*/
	}
}
