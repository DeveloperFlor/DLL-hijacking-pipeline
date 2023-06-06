# Automated DLL Hijacking Pipeline

Disclaimer: The following disclosure is intended to inform users about the risks associated with DLL hijacking and to emphasize responsible usage. Please exercise caution and ensure compliance with applicable laws and regulations when utilizing the information provided below.

1. Purpose:
   The purpose of this disclosure is to provide information about a DLL hijacking pipeline script. The script aims to demonstrate potential vulnerabilities within software applications by exploiting DLL search order hijacking techniques. It is designed for educational and ethical purposes only.

2. Description:
   The DLL hijacking pipeline script is a tool that facilitates the identification and exploitation of DLL search order hijacking vulnerabilities in software applications. By manipulating the dynamic-link library (DLL) loading process, the script aims to load malicious or unintended DLLs into an application's execution flow. This demonstration highlights the importance of secure coding practices and the need for proper DLL loading mechanisms.

3. Legal and Ethical Use:
   The DLL hijacking pipeline script should only be used in accordance with the law and for legitimate purposes, such as education, research, or in a controlled environment for testing and assessing the security of software applications with proper authorization. Unauthorized use, misuse, or any activity that violates the law or compromises the security of systems without permission is strictly prohibited.

4. Responsibilities:
   Users of the DLL hijacking pipeline script are solely responsible for any actions they undertake with the tool. It is crucial to ensure that the script is used only on applications or systems that users have permission to assess and that all relevant legal and ethical guidelines are followed. The creators and maintainers of the script are not liable for any damages or legal consequences resulting from the misuse or inappropriate use of the tool.

5. Awareness and Mitigation:
   The DLL hijacking pipeline script is intended to raise awareness among software developers, system administrators, and security professionals regarding the risks associated with DLL hijacking vulnerabilities. By understanding these risks, it becomes possible to implement appropriate countermeasures, such as secure DLL loading techniques, using absolute paths, or employing proper digital signatures for DLL verification.

6. Reporting Vulnerabilities:
   If, during the usage of the DLL hijacking pipeline script, you identify a potential DLL hijacking vulnerability in a specific software application, it is strongly encouraged to report it responsibly to the respective vendor or developer. Engage in responsible disclosure practices, allowing the vendor sufficient time to address and remediate the vulnerability before making it public.

7. Conclusion:
   The DLL hijacking pipeline script is a tool that aims to educate users about the dangers of DLL hijacking vulnerabilities. Responsible usage, adherence to applicable laws, and ethical considerations are paramount. By employing this tool within a controlled environment, users can better understand the risks associated with DLL search order hijacking and contribute to the overall improvement of software security.

Remember, knowledge and tools should always be used responsibly, with respect for the law and the security of others.

## Prerequisites

- Powershell - Present on modern Windows machines

- The `.\Tools\` folder must include:
  
  - NetClone --> [GitHub](https://github.com/monoxgas/Koppeling)
  
  - Procmon.exe --> [Process Monitor - Sysinternals | Microsoft Learn](https://learn.microsoft.com/en-us/sysinternals/downloads/procmon)
  
  - sigcheck64.exe --> [Sigcheck - Sysinternals | Microsoft Learn](https://learn.microsoft.com/en-us/sysinternals/downloads/sigcheck)
  
  - Spartacus-v1.2.0-x64.exe --> [GitHub](https://github.com/Accenture/Spartacus)

- Payload both for a 64-bit and 32-bit application; Read the paper for more information, a template can be found in `payload_template.cpp` 
  
  Compile these payloads to the root directory with the following naming:
  
  64-bit: `payloadx64.dll`
  
  32-bit: `payloadx32.dll`

## Running the script

Navigate in an elevated powershell terminal to the root folder of the hijacking pipeline and execute the following command:

`PowerShell.exe -ExecutionPolicy UnRestricted -File .\hijack.ps1`

This will start the script.

Input the path to the application you want to hijack, ex: `C:\Users\Flor\AppData\Local\Microsoft\Teams\current\Teams.exe`

A list with vulnerable DLLs will be generated, select the preffered DLL by inputting the corresponding number and press enter. 
Now that DLL is being hijacked and a proxy is created. 


