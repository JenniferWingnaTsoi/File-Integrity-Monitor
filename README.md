# File Integrity Monitoring (FIM) Project

The File Integrity Monitoring (FIM) project implemented in PowerShell provides a solution for monitoring the integrity of files within a specified directory. It aims to detect any unauthorized modifications, creations, or deletions of files and promptly notify the user through email notifications. The project utilizes cryptographic hashing techniques to calculate and compare file hashes, ensuring the integrity and security of the monitored files.

### Project Overview

The FIM project demonstrates the following key features and skills:

- PowerShell Scripting: The project is developed using PowerShell scripting, showcasing the ability to automate tasks, manipulate files and directories, interact with the operating system, and utilize PowerShell cmdlets effectively.

- Cryptographic Hashing: The project utilizes the SHA512 hashing algorithm to calculate the hash values of files. This demonstrates an understanding of cryptographic concepts and the ability to leverage hashing algorithms for data integrity verification.

- File Manipulation: The project involves working with files and directories, including reading file contents, calculating file hashes, comparing files, creating and appending to files, and removing files. This showcases skills in file manipulation and management using PowerShell cmdlets.

- Email Notifications: The project incorporates email notifications to inform the user about detected changes in the monitored files. It demonstrates the ability to configure and utilize SMTP server settings, send emails, and customize email content using PowerShell.

- Baseline Creation and Comparison: The project implements the concept of baselines, allowing the user to establish an initial set of file hashes as a reference point. It then compares the current file hashes with the baseline to identify changes. This showcases skills in baseline creation, comparison, and tracking.

- Monitoring and Reporting: The project includes continuous monitoring of files for modifications, creations, and deletions. It generates detailed reports containing file paths, statuses, and hash values. This demonstrates skills in monitoring techniques, generating reports, and presenting information in a readable format.

- Error Handling: The project incorporates error handling mechanisms, such as checking for existing baseline files and handling exceptions during file operations. This showcases skills in handling potential errors and ensuring the reliability and robustness of the script.

### Usage

To use the FIM project, follow these steps:

1. Clone or download the project files.

1. Configure the SMTP server settings in the `Send-EmailNotification` function to match your email provider's requirements.

1. Run the script and choose an action: collecting a new baseline, monitoring files, or generating detailed reports.

   - **Collect New Baseline**: Selecting this option will calculate the file hashes for all files in the specified directory and create a new baseline file.

   - **Monitor Files**: This option continuously monitors files in the specified directory for changes. If any modifications, creations, or deletions are detected, an email notification will be sent.

   - **Generate Detailed Reports**: Selecting this option will generate a detailed report containing the current status and hashes of the monitored files.

### Dependencies

The FIM project has the following dependencies:

- PowerShell 5.1 or later

### Limitations

- The project currently supports monitoring files within a single specified directory only.

- The SMTP server settings need to be correctly configured for email notifications to work.

### Conclusion

The File Integrity Monitoring project in PowerShell combines skills in scripting, cryptographic hashing, file manipulation, email notifications, baseline creation and comparison, monitoring, reporting, and error handling. These skills collectively enable the project to detect and notify users about unauthorized changes to files, ensuring data integrity and security.

For more information and detailed usage instructions, refer to the project documentation and comments within the script files.
