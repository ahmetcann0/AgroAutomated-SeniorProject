package database;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.auth.oauth2.ServiceAccountCredentials;
import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Bucket;
import com.google.cloud.storage.BucketInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.StorageClient;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

public class FirebaseStorageInteraction{
	private String credentials ;
    private String DATABASE_URL;
    private Storage storage;
    private String bucketName = "agroautomated-8f55e.appspot.com";
    private boolean storageInitialized = false;

    private FirebaseDatabase firebaseDatabase;
    
    private static FirebaseStorageInteraction firebaseStorageInteraction = null; //Singleton instance.


    private FirebaseStorageInteraction() throws IOException {
    	credentials = "C:\\\\Users\\\\Deniz\\\\eclipse-workspace\\\\FirebaseInteraction\\\\agroautomated-8f55e-firebase-adminsdk-mdmjm-56a8631d3b.json";
    	DATABASE_URL = "https://agroautomated-8f55e-default-rtdb.firebaseio.com/";
    }
    public void initialize() throws IOException {
        
        storage = StorageOptions.newBuilder()
                .setCredentials(ServiceAccountCredentials.fromStream(new FileInputStream(credentials)))
                .build()
                .getService();
    	storageInitialized = true;
        
    }
    public synchronized static FirebaseStorageInteraction getInstance() throws IOException {
    	if(firebaseStorageInteraction == null)
    		firebaseStorageInteraction = new FirebaseStorageInteraction();
		return firebaseStorageInteraction;
    }
    @SuppressWarnings("deprecation")
	public void uploadAFileToStorage(String localFilePath, String filename) {
    	String databaseStorageLocation = "data/" + filename;
        
    	if(storageInitialized == true) {
	        try (InputStream testFile = new FileInputStream(localFilePath+filename)) {
	        	
	            BlobInfo blobInfo = BlobInfo.newBuilder(bucketName, databaseStorageLocation)
	                    .setContentType("text/plain")
	                    .build();
	            
	            storage.create(blobInfo, testFile); //Upload the file but "create" is deprecated why????
	            System.out.println("File Uploaded to Firebase Storage!!!");
	        } catch (Exception e) {
	            System.err.println("Dosya yüklenirken bir hata oluştu: " + e.getMessage());
	        }
    	}
    	else     		
    		System.out.println("Firebase Storage did not initialize please call \"initialize()\" first!" );

    }
    public void downloadAFile(String foldername,String filename) throws IOException  {
    	if(storageInitialized == true) {
    		Blob blob = storage.get(bucketName, foldername+"/"+filename);
    		if (blob != null)
    			blob.downloadTo(Paths.get("C:\\Users\\Deniz\\OneDrive\\Belgeler\\GitHub\\agroautomated_cloned\\agroautomated\\backend_most_new\\WebSocketApp\\src\\downloadedFiles\\download.txt"));
    		else System.out.println("blob is null!!!!!");
    	}
    	else 
    		System.out.println("Firebase Storage did not initialize please call \"initialize()\" first!" );
    		
    }
    public void close() {
    	FirebaseDatabase.getInstance().getApp().delete();
    }

    
}
