package generatemylibrarywindows;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.sound.sampled.UnsupportedAudioFileException;
import tag.MpegInfo;
import tag.OggVorbisInfo;

/**
 * Soundtrack.java
 * @author Lunaqua
 * Holds the Soundtrack and SoundtrackMusic directories
 */
public class Soundtrack {

    private File addonDir;
    private File musicDir;
    private File currentDir;
    private boolean wrongFolder;
    private int oggcount;
    private int mp3count;
    private int foldercount;
    private javax.swing.JTextArea TextArea;
    private String libraryErrors = "";

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
        currentDir = new File(curDir);
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
     * Returns folder count.
     * @return foldercount
     */
    public int getfoldercount(){
        return foldercount;
    }

    /**
     * Returns mp3 count.
     * @return mp3count
     */
    public int getmp3count(){
        return mp3count;
    }

    /**
     * Returns ogg count.
     * @return oggcount
     */
    public int getoggcount() {
        return oggcount;
    }

    /**
     * Resets the counters.
     */
    public void resetCounts(){
        oggcount = 0;
        mp3count = 0;
        foldercount = 0;
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
     * Copies files from strpath to dstpath.
     * NB: Call resetCounts() before this function.
     * @param srcPath String source path for files/folders to copy
     * @param dstPath String copy destination path
     */
    public void addFiles(String srcPath, String dstPath){
        resetCounts();
        final String src = srcPath;
        final String dst = dstPath;
        class ThreadAddFiles implements Runnable{
            public void run(){
                threadAddFiles(src, dst);
                log("Summary:");
                log(mp3count+" mp3 files added.");
                log(foldercount+" folders added.");
            }
        }
        Runnable runnable = new ThreadAddFiles();
        Thread thread = new Thread(runnable);
        thread.start();
    }

    /**
     * Copies files from strpath to dstpath.
     * Called in addFiles().
     * @param srcPath String source path for files/folders to copy
     * @param dstPath String copy destination path
     */
    private void threadAddFiles(String srcPath, String dstPath) {

        File src = new File(srcPath);
        File dest = new File(dstPath);

        if (src.isDirectory()) {
            boolean created = dest.mkdirs();
            String list[] = src.list();
            foldercount++;
            for (int i = 0; i < list.length; i++) {
                String dest1 = dest.getAbsolutePath() + File.separator + list[i];
                String src1 = src.getAbsolutePath() + File.separator + list[i];
                threadAddFiles(src1, dest1);
            }
        } else {
            try {
                String ext = src.getName().toUpperCase();
                if (ext.endsWith(".MP3") || ext.endsWith(".TOC")) {
                    if(ext.endsWith(".MP3")){
                        log("Copying " + src.getName() + "   (" + src.getPath() + ")");
                        mp3count++;
                    }
                    FileChannel sourceChannel = new FileInputStream(src).getChannel();
                    FileChannel targetChannel = new FileOutputStream(dest).getChannel();
                    sourceChannel.transferTo(0, sourceChannel.size(), targetChannel);
                    sourceChannel.close();
                    targetChannel.close();
                } else {
                    log("Error: Cannot add "+src.getName());
                }

            } catch (IOException ex) {
                Logger.getLogger(Soundtrack.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    /**
     * Deletes the files at srcPath.
     * NB: Call resetCounts() before this function.
     * @param srcPath String source path
     */
    public void deleteFiles(String srcPath) {
        final String src = srcPath;
        class ThreadDeleteFiles implements Runnable {
            public void run() {
                threadDeleteFiles(src);
                log("Summary:");
                log(mp3count+" mp3 files deleted.");
                log(foldercount+" folders deleted.");
            }
        }
        Runnable runnable = new ThreadDeleteFiles();
        Thread thread = new Thread(runnable);
        thread.start();
    }

    /**
     * Deletes the files at the strpath.
     * Called in deleteFiles().
     * @param strPath delete path
     */
    private void threadDeleteFiles(String strPath){

        File src = new File(strPath);

        if (src.isDirectory()) {
            String list[] = src.list();

            for (int i = 0; i < list.length; i++) {
                String src1 = src.getAbsolutePath() + File.separator + list[i];
                deleteFiles(src1);
                foldercount++;
                src.delete();
            }
        } else {
            String ext = src.getName().toUpperCase();
            if (ext.endsWith(".MP3")) {
                log("Deleting " + src.getName() + "   (" + src.getPath() + ")");
                mp3count++;
                src.delete();
            } else {
                return;
            }
        }
    }


    /**
     * Generates MyTracks.lua
     */
    public void generateMyLibrary() {
        String mytracks = musicDir + "\\MyTracks.lua";
        libraryErrors = "";
        try{
            // Create file
            FileWriter fstream = new FileWriter(mytracks);
            final BufferedWriter out = new BufferedWriter(fstream);
            final File source = musicDir;
            class ThreadGenMyLib implements Runnable {
                public void run() {
                    try {
                        log("Starting MyTracks.lua");
                        out.write("-- This file is automatically generated\n");
                        out.write("-- Please do not edit it.\n");
                        out.write("function Soundtrack_LoadMyTracks()\n");
                        threadWriteTracks(source, out);
                        out.write("end\n");
                        out.close();
                        log("--- --- ---");
                        log("MyTracks.lua COMPLETE!");
                        log("Number of tracks: "+mp3count);
                    } catch (IOException ex) {
                        Logger.getLogger(Soundtrack.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (UnsupportedAudioFileException ex) {
                        Logger.getLogger(Soundtrack.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
            Runnable runnable = new ThreadGenMyLib();
            Thread thread = new Thread(runnable);
            thread.start();
        }catch (Exception e){//Catch exception if any
            log("Error@generateMyLibrary: " + e.getMessage());
        }
    }

    /**
     * Writes tracks to MyTracks.lua, called in generateMyLibrary
     * @param src source file/folder
     * @param out file to write to
     * @throws IOException
     * @throws UnsupportedAudioFileException
     */
    private void threadWriteTracks(File src, BufferedWriter out)
            throws IOException, UnsupportedAudioFileException {
        if (src.isDirectory()) {
            String list[] = src.list();
            for(int i=0; i<list.length; i++){
                String nextSrcPath = src.getAbsolutePath() + File.separator + list[i];
                File nextSrc = new File(nextSrcPath);
                threadWriteTracks(nextSrc, out);
            }
        }else {
            String ext = src.getName().toUpperCase();
            if (ext.endsWith(".MP3")) {
                log("--- --- ---");
                MpegInfo mp3i = new MpegInfo();
                mp3i.load(src);
                // Get file path
                String filePath = src.getPath();
                filePath = filePath.substring(musicDir.getPath().length()+1);
                for(int i=0; i<filePath.length(); i++){
                    if (filePath.charAt(i) == '\\') {
                        StringBuffer sb = new StringBuffer(filePath);
                        sb.insert(i, "\\");
                        filePath = sb.toString();
                        i++;
                    }
                }
                filePath = filePath.substring(0, filePath.length()-4);

                // Get title
                String title = mp3i.getTitle();
                if (title == null || title.equals("")){
                    title = src.getName().substring(0, src.getName().length()-4);
                }
                for(int i=0; i<title.length(); i++){
                    if (title.charAt(i) == '\"') {
                        StringBuffer sb = new StringBuffer(title);
                        sb.insert(i, "\\");
                        title = sb.toString();
                        i++;
                    }
                }

                // Get artist
                String artist = mp3i.getArtist();
                if (artist == null || artist.equals("")){
                    artist = "null";
                }
                for(int i=0; i<artist.length(); i++){
                    if (artist.charAt(i) == '\"') {
                        StringBuffer sb = new StringBuffer(artist);
                        sb.insert(i, "\\");
                        artist = sb.toString();
                        i++;
                    }
                }

                // Get album
                String album = mp3i.getAlbum();
                if (album == null || album.equals("")){
                    File parent = new File(src.getParent());
                    album = parent.toString().substring(parent.getParent().length()+1);
                }
                for(int i=0; i<album.length(); i++){
                    if (album.charAt(i) == '\"') {
                        StringBuffer sb = new StringBuffer(album);
                        sb.insert(i, "\\");
                        album = sb.toString();
                        i++;
                    }
                }

                int length = (int) mp3i.getPlayTime();
                if (length == 0) {
                    length = 1;
                }

                mp3count++;
                out.write("    Soundtrack.Library.AddTrack(\""+filePath+"\","+length+",\""
                        +title+"\",\""+artist+"\",\""+album+"\")\n");
                log(mp3count + ": " + filePath + " = \"" + title + "\"; \"" + artist + "\"; \"" + album + "\"; "
                        + length + " seconds");
            } else {
                log("--- --- ---");
                log("ERROR: Cannot add "+src.getPath());
                libraryErrors = libraryErrors + src.getPath() + "\n";
            }
        }
    }



    /**
     * Generates DefaultTracks.lua
     */
    public void generateDefaultLibrary() {
        String defaulttracks = currentDir+"\\DefaultTracks.lua";
        libraryErrors = "";
        try{
            // Create file
            FileWriter fstream = new FileWriter(defaulttracks);
            final BufferedWriter out = new BufferedWriter(fstream);
            final File source = currentDir;
            class ThreadGenDefaultLib implements Runnable {
                public void run() {
                    try {
                        log("Starting DefaultTracks.lua");
                        out.write("function Soundtrack_LoadDefaultTracks()\n");
                        threadWriteDefaultTracks(source, out);
                        out.write("   Soundtrack.SortTracks()\n");
                        out.write("end\n");
                        out.close();
                        log("--- --- ---");
                        log("DefaultTracks.lua COMPLETE!");
                        log("Number of tracks: "+mp3count);
                    } catch (IOException ex) {
                        Logger.getLogger(Soundtrack.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (UnsupportedAudioFileException ex) {
                        Logger.getLogger(Soundtrack.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
            Runnable runnable = new ThreadGenDefaultLib();
            Thread thread = new Thread(runnable);
            thread.start();
        }catch (Exception e){//Catch exception if any
            log("Error@generateDefaultLibrary: " + e.getMessage());
        }
    }

    /**
     * Writes tracks to DefaultTracks.lua, called in generateMyLibrary
     * @param src source file/folder
     * @param out file to write to
     * @throws IOException
     * @throws UnsupportedAudioFileException
     */
    private void threadWriteDefaultTracks(File src, BufferedWriter out)
            throws IOException, UnsupportedAudioFileException {
        if (src.isDirectory()) {
            String list[] = src.list();
            for(int i=0; i<list.length; i++){
                String nextSrcPath = src.getAbsolutePath() + File.separator + list[i];
                File nextSrc = new File(nextSrcPath);
                threadWriteDefaultTracks(nextSrc, out);
            }
        }else {
            String ext = src.getName().toUpperCase();
            if (ext.endsWith(".MP3")) {
                log("--- --- ---");
                MpegInfo mp3i = new MpegInfo();
                mp3i.load(src);
                String filePath = src.getPath();
                filePath = filePath.substring(currentDir.getPath().length()+1);
                for(int i=0; i<filePath.length(); i++){
                    if (filePath.charAt(i) == '\\') {
                        StringBuffer sb = new StringBuffer(filePath);
                        sb.insert(i, "\\");
                        filePath = sb.toString();
                        i++;
                    }
                }
                filePath = filePath.substring(0, filePath.length()-4);
                
                // Get title
                String title = mp3i.getTitle();
                if (title == null || title.equals("")){
                    title = src.getName().substring(0, src.getName().length()-4);
                }
                for(int i=0; i<title.length(); i++){
                    if (title.charAt(i) == '\"') {
                        StringBuffer sb = new StringBuffer(title);
                        sb.insert(i, "\\");
                        title = sb.toString();
                        i++;
                    }
                }

                // Get artist
                String artist = mp3i.getArtist();
                if (artist == null || artist.equals("")){
                    artist = "null";
                }
                for(int i=0; i<artist.length(); i++){
                    if (artist.charAt(i) == '\"') {
                        StringBuffer sb = new StringBuffer(artist);
                        sb.insert(i, "\\");
                        artist = sb.toString();
                        i++;
                    }
                }

                // Get album
                String album = mp3i.getAlbum();
                if (album == null || album.equals("")){
                    File parent = new File(src.getParent());
                    album = parent.toString().substring(parent.getParent().length()+1);
                }
                for(int i=0; i<album.length(); i++){
                    if (album.charAt(i) == '\"') {
                        StringBuffer sb = new StringBuffer(album);
                        sb.insert(i, "\\");
                        album = sb.toString();
                        i++;
                    }
                }

                int length = (int) mp3i.getPlayTime();
                if (length == 0) {
                    length = 1;
                }

                mp3count++;
                out.write("    Soundtrack.Library.AddDefaultTrack(\""+filePath+"\","+length+",\""
                        +title+"\",\""+artist+"\",\""+album+"\")\n");
                log(mp3count + ": " + filePath + " = \"" + title + "\"; \"" + artist + "\"; \"" + album + "\"; "
                        + length + " seconds");
            } else {
                log("--- --- ---");
                log("ERROR: Cannot add "+src.getPath());
                libraryErrors = libraryErrors + src.getPath() + "\n";
            }
        }
    }


    /**
     * Generates DefaultSounds.lua
     */
    public void generateSoundsLibrary() {
        String mytracks = currentDir+"\\DefaultSounds.lua";
        libraryErrors = "";
        try{
            // Create file
            FileWriter fstream = new FileWriter(mytracks);
            final BufferedWriter out = new BufferedWriter(fstream);
            final File source = currentDir;
            class ThreadGenSoundsLib implements Runnable {
                public void run() {
                    try {
                        log("Starting DefaultSounds.lua");
                        out.write("function Soundtrack_LoadDefaultSounds()\n");
                        threadWriteOggTracks(source, out);
                        out.write("   Soundtrack.SortTracks()\n");
                        out.write("end\n");
                        out.close();
                        log("--- --- ---");
                        log("DefaultSounds.lua COMPLETE!");
                        log("Number of tracks: "+mp3count);
                    } catch (IOException ex) {
                        Logger.getLogger(Soundtrack.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (UnsupportedAudioFileException ex) {
                        Logger.getLogger(Soundtrack.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
            Runnable runnable = new ThreadGenSoundsLib();
            Thread thread = new Thread(runnable);
            thread.start();
        }catch (Exception e){//Catch exception if any
            log("Error@generateDefaultLibrary: " + e.getMessage());
        }
    }

    /**
     * Writes OGG files to DefaultSounds.lua. 
     * @param src source file
     * @param out file to write to
     * @throws IOException
     * @throws UnsupportedAudioFileException
     */
    private void threadWriteOggTracks(File src, BufferedWriter out)
            throws IOException, UnsupportedAudioFileException {
        if (src.isDirectory()) {
            String list[] = src.list();
            for(int i=0; i<list.length; i++){
                String nextSrcPath = src.getAbsolutePath() + File.separator + list[i];
                File nextSrc = new File(nextSrcPath);
                threadWriteTracks(nextSrc, out);
            }
        }else {
            String ext = src.getName().toUpperCase();
            log(ext);
            if (ext.endsWith(".OGG")) {
                log("--- --- ---");
                OggVorbisInfo oggi = new OggVorbisInfo();
                oggi.load(src);
                String filePath = src.getPath();
                filePath = filePath.substring(currentDir.getPath().length()+1);
                for(int i=0; i<filePath.length(); i++){
                    if (filePath.charAt(i) == '\\') {
                        StringBuffer sb = new StringBuffer(filePath);
                        sb.insert(i, "\\");
                        filePath = sb.toString();
                        i++;
                    }
                }
                filePath = filePath.substring(0, filePath.length()-4);

                // Get title
                String title = oggi.getTitle();
                if (title == null || title.equals("")){
                    title = src.getName().substring(0, src.getName().length()-4);
                }
                for(int i=0; i<title.length(); i++){
                    if (title.charAt(i) == '\"') {
                        StringBuffer sb = new StringBuffer(title);
                        sb.insert(i, "\\");
                        title = sb.toString();
                        i++;
                    }
                }

                // Get artist
                String artist = oggi.getArtist();
                if (artist == null || artist.equals("")){
                    artist = "null";
                }
                for(int i=0; i<artist.length(); i++){
                    if (artist.charAt(i) == '\"') {
                        StringBuffer sb = new StringBuffer(artist);
                        sb.insert(i, "\\");
                        artist = sb.toString();
                        i++;
                    }
                }

                // Get album
                String album = oggi.getAlbum();
                if (album == null || album.equals("")){
                    File parent = new File(src.getParent());
                    album = parent.toString().substring(parent.getParent().length()+1);
                }
                for(int i=0; i<album.length(); i++){
                    if (album.charAt(i) == '\"') {
                        StringBuffer sb = new StringBuffer(album);
                        sb.insert(i, "\\");
                        album = sb.toString();
                        i++;
                    }
                }

                int length = (int) oggi.getPlayTime();
                if (length == 0) {
                    length = 1;
                }
                
                mp3count++;
                out.write("    Soundtrack.Library.AddDefaultSound(\""+filePath+"\","+length+",\""
                        +title+"\",\""+artist+"\",\""+album+"\")\n");
                log(mp3count + ": " + filePath + " = \"" + title + "\"; \"" + artist + "\"; \"" + album + "\"; "
                        + length + " seconds");
            } else {
                log("--- --- ---");
                log("ERROR: Cannot add "+src.getPath());
                libraryErrors = libraryErrors + src.getPath() + "\n";
            }
        }
    }
    

    /**
     * Logs a string to the TextArea.
     * @param str string to log
     */
    public void log(String str) {
        TextArea.append(str+"\n");
        TextArea.validate();
    }

    /**
     * Lists file errors from the last run of generate library.
     */
    public void getGenLibErrors() {
        log("--- --- ---");
        log("ERROR FILES:");
        log(libraryErrors);
    }

} // end of class