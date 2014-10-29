<HTML>
<HEAD>
<TITLE>Image Upload</TITLE>
</HEAD>
<BODY>

<H1>Upload Image</H1>

<form name="upload-image" method="POST" enctype="multipart/form-data" action="UploadImage">
<table>
 
</table>
Please input or select the path of the image!
<table>
  <tr>
    <th>File path: </th>
    <td><input name="file-path" type="file" size="30" ></input></td>
  </tr>
  <tr>
    <th>Subject:</th>
    <td><input type="text" name="SUBJECT" maxlength="128" size="128"></td>
  </tr>
  <tr>
    <th>Place:</th>
    <td><input type="text" name="PLACE" maxlength="128" size="128"></td>
  </tr>
  <tr>
    <th>Description:</th>
    <td><textarea type="text" name="DESCRIPTION" maxlength="2048" rows="32" cols="64" ></textarea></td>
  </tr>
  <tr>
    <td ALIGN=CENTER COLSPAN="2"><input type="submit" name=".submit" 
     value="Upload"></td>
  </tr>
</table>
</form>
<%
   String error=(String)session.getAttribute("error");
   if (error!=null){
      out.println(error);
      session.removeAttribute("error");
   }
%>
</BODY> 
</HTML>
