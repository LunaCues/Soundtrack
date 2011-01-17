import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;

/**
 * Creates junctions.
 * @author Jessica
 * @modifier Katherine
 */
public class Junction {

    private javax.swing.JTextArea TextArea;
    private boolean vista;

    /**
     * Creates a new Junction object with text area for logging
     * @param jta JTextArea
     * @throws Exception
     */
    public Junction(javax.swing.JTextArea jta) throws Exception {
        TextArea = jta;
        
        System.out.println("OS="+System.getProperty("os.name"));
        if (System.getProperty("os.name").equalsIgnoreCase("Windows Vista") | System.getProperty("os.name").equalsIgnoreCase("Windows 7")) {
            vista = true;
        } else if (System.getProperty("os.name").equalsIgnoreCase("Windows XP")) {
            if(new File("junction/junction.exe").exists()){
                //xp and junction.exe found
                vista = false;
                //junction.exe /accepteula
                execCommand("junction/junction.exe /accepteula");
            }
            else
            {
                throw new Exception("junction.exe not found.");
            }
        } else {
            throw new Exception("OS not supported");
        }
    }

    /**
     * Creates a link from the current directory to the target directory.
     * @param linkname name of link file
     * @param target target directory
     * @throws IOException
     */
    public void createlink(String linkname, String target) throws IOException {

        if (new File(linkname).exists()) {
            //throw new IOException("link: "+linkname + " already exists.");
            Log("Error: Junction already exists.");
        }

        String command;
        if (vista) {
            command = "cmd /C mklink /J \"" + linkname + "\" \"" + target + "\"" + "\n";
        } else {
            command = "junction/junction.exe \"" + linkname + "\" \"" + target + "\"";
        }

        System.out.println(command);
        execCommand(command);

        if (!new File(linkname).exists()) {
            //throw new IOException("Could not create link from " + linkname + " to " + target);
            Log("Error: Could not create junction from " + linkname + " to " + target);
        }
    }

    /**
     * Executes a command in the command line.
     * @param command command to execute
     * @return 0 if successfully run
     * @throws IOException
     */
    public int execCommand(String command) throws IOException {
        String line;
        OutputStream stdin = null;
        InputStream stderr = null;
        InputStream stdout = null;


        Process process = Runtime.getRuntime().exec(command);

        stdin = process.getOutputStream();
        stderr = process.getErrorStream();
        stdout = process.getInputStream();

        stdin.close();

        // clean up if any output in stdout
        BufferedReader brCleanUp =
                new BufferedReader(new InputStreamReader(stdout));
        while ((line = brCleanUp.readLine()) != null) {
            System.out.println("[Stdout] " + line);
        }
        brCleanUp.close();

        // clean up if any output in stderr
        brCleanUp =
                new BufferedReader(new InputStreamReader(stderr));
        while ((line = brCleanUp.readLine()) != null) {
            System.out.println("[Stderr] " + line);
        }
        brCleanUp.close();
        System.out.println(process.exitValue());
        return process.exitValue();
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