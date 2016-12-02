public class Test {

	public static void main(String[] args) {
        // InputStream is = null;
        String totalMessage = "";
        String url = "http://192.168.0.10:8080/soccer.do?method=list";
        HttpClient httpclient = new DefaultHttpClient();
        // try {
        //     HttpPost httppost = new HttpPost(url);
        //     UrlEncodedFormEntity entityRequest =
        // new UrlEncodedFormEntity(nameValuePairs, "UTF-8");
        //     httppost.setEntity(entityRequest);

//            HttpResponse response = httpclient.execute(httppost);
//            HttpEntity entityResponse = response.getEntity();
//            is = entityResponse.getContent();
//
//            /** convert response to string */
//            BufferedReader reader = new BufferedReader(new InputStreamReader(
//                    is, "iso-8859-1"), 8);
//            StringBuilder sb = new StringBuilder();
//            String line = null;
//            while ((line = reader.readLine()) != null) {
//                sb.append(line).append("\n");
//            }
//            is.close();
//            result = sb.toString();

 //        } catch (IOException e) {
 //            e.printStackTrace();
 //        } chatch (Exception e)
 //            e.printStackTrace();

 //        } finally {
 //            tmp = httpclient.getConnectionManager();
 //            tmp.shutdown();
 //        }
	}
}
