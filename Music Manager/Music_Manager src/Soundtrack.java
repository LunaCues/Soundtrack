
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Soundtrack.java
 * @author Lunaqua
 * Holds the Soundtrack and SoundtrackMusic directories
 */
public class Soundtrack {

    private File addonDir;
    private File musicDir;
    private boolean wrongFolder;
    private int mp3count;
    private javax.swing.JTextArea TextArea;

    /**
     * Creates a Soundtrack object with a JTextArea to log to.
     * @param jta JTextArea for logging
     */
    public Soundtrack(javax.swing.JTextArea jta){
        setDirectories();
        resetCounts();
        setTextArea(jta);
    }

    /**
     * Sets the Soundtrack and SoundtrackMusic directories,
     * sets wrongFolder to true if Soundtrack is not in AddOns folder.
     */
    private void setDirectories(){
        wrongFolder = false;

        String curDir = System.getProperty("user.dir");
        curDir = curDir.substring(0, curDir.length()-14);
        addonDir = new File(curDir);

        // Check if Soundtrack is in Addons folder
        String d = curDir.substring(curDir.length()-6-11);  // Grabs last 6 chars.
        if(!d.equalsIgnoreCase("addons\\soundtrack")){
            wrongFolder = true;
        }

        musicDir = new File(addonDir + "Music");
        if(!musicDir.exists()) {
            musicDir.mkdir();
        }
    }

    /**
     * Returns the Soundtrack directory as a File object.
     * @return Soundtrack directory
     */
    public File getAddonDir(){
        return addonDir;
    }

    /**
     * Returns the SoundtrackMusic directory as a File object.
     * @return SoundtrackMusic directory
     */
    public File getMusicDir(){
        return musicDir;
    }

    /**
     * Returns mp3 count.
     * @return mp3count
     */
    public int getmp3count(){
        return mp3count;
    }

    /**
     * Resets the counters.
     */
    public void resetCounts(){
        mp3count = 0;
    }

    /**
     * Returns if Soundtrack is not in AddOns folder.
     * @return wrongFolder
     */
    public boolean getWrongFolder(){
        return wrongFolder;
    }

    /**
     * Sets the TextArea for logging.
     * @param jta JTextArea
     */
    private void setTextArea(javax.swing.JTextArea jta){
        TextArea = jta;
    }

    /**
     * Copies files from strpath to dstpath
     * NB: Call resetCounts() before this function.
     * @param strPath path for files/folders to copy
     * @param dstPath copy destination path
     */
    public void CopyAddFiles(String strPath, String dstPath) {

        File src = new File(strPath);
        File dest = new File(dstPath);

        if (src.isDirectory()) {
            boolean created = dest.mkdirs();
            String list[] = src.list();

            for (int i = 0; i < list.length; i++) {
                String dest1 = dest.getAbsolutePath() + File.separator + list[i];
                String src1 = src.getAbsolutePath() + File.separator + list[i];
                CopyAddFiles(src1, dest1);
            }
        } else {
            try {
                String ext = src.getName().toUpperCase();
                if (ext.endsWith(".MP3") || ext.endsWith(".TOC")) {
                    if(ext.endsWith(".MP3")){
                        Log("Copying " + src.getName() + "   (" + src.getPath() + ")");
                        mp3count++;
                    }
                    FileChannel sourceChannel = new FileInputStream(src).getChannel();
                    FileChannel targetChannel = new FileOutputStream(dest).getChannel();
                    sourceChannel.transferTo(0, sourceChannel.size(), targetChannel);
                    sourceChannel.close();
                    targetChannel.close();
                } else {
                    return;
                }

            } catch (IOException ex) {
                Logger.getLogger(SoundtrackMusicGUI.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    /**
     * Deletes the files at the strpath. 
     * NB: Call resetCounts() before this function.
     * @param strPath delete path
     */
    public void DeleteFiles(String strPath){

        File src = new File(strPath);

        if (src.isDirectory()) {
            String list[] = src.list();

            for (int i = 0; i < list.length; i++) {
                String src1 = src.getAbsolutePath() + File.separator + list[i];
                DeleteFiles(src1);
                src.delete();
            }
        } else {
            String ext = src.getName().toUpperCase();
            if (ext.endsWith(".MP3")) {
                Log("Deleting " + src.getName() + "   (" + src.getPath() + ")");
                mp3count++;
                src.delete();
            } else {
                return;
            }
        }
    }

    /**
     * Logs a string to the TextArea.
     * @param str string to log
     */
    public void Log(String str) {
        TextArea.append(str + "\n");
        TextArea.validate();
    }
}
