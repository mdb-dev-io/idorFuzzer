# idorFuzzer
A Bash script designed to automate the testing for IDOR vulnerabilities by fuzzing parameters through GET or POST requests, supporting both numerical ranges and file lists for input.

---

**Introduction:**
- This script is designed to automate testing for Insecure Direct Object Reference (IDOR) vulnerabilities.
- It supports both GET and POST requests and allows for fuzzing parameters using a range of values or a predefined list.

**Prerequisites:**
- Bash environment (Linux/Unix or Windows Subsystem for Linux)
- `curl` installed and accessible from the command line

**Usage Instructions:**

1. **Setting Up:**
   - Clone or download this script to your local machine.
   - Ensure it is executable: `chmod +x IDORFuzzer.sh`

2. **Running the Script:**
   - Execute the script by typing `./IDORFuzzer.sh` in your terminal.
   - Follow the on-screen prompts to input your test parameters.

3. **Input Parameters:**
   - **URL**: The base URL you wish to test for IDOR vulnerabilities.
   - **HTTP Method**: Choose between GET or POST method for the requests.
   - **Directory**: The directory to search (e.g., 'uploads'), omitting the forward slash '/'.
   - **Parameter Name**: The parameter you wish to fuzz (e.g., 'uid'), omitting the equals '='.
   - **Range/File List**: Choose between using a numerical range (R) or a file list (F) for fuzzing the parameter.

4. **Output:**
   - The script attempts to identify and download resources exposed due to IDOR vulnerabilities.
   - Downloaded resources are saved in the script's running directory.

**Note:**
- Always use this script with permission on target domains to avoid unauthorized access and potential legal issues.
- The effectiveness of the script depends on the correctness of the inputs and the specific configurations of the target application.

**Contributing:**
- Contributions to enhance this script are welcome. Please fork the repository, make your changes, and submit a pull request.

**License:**
- This script is provided "as is", without warranty of any kind. Use at your own risk.

**Disclaimer:**
- This tool is intended for educational and ethical testing purposes only. The author is not responsible for any misuse or damage caused by this tool.
