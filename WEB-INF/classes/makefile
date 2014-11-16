all:
	javac Database/db.java
	javac -cp ../lib/ojdbc6.jar:.:../lib/commons-fileupload-1.0.jar:.:../lib/servlet-api.jar UploadImage.java
	BrowseGallery.java
clean:
	rm -f Database/db.class
	rm -f UploadImage.class
	rm -f BrowseGallery.class