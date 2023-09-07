<center><h1>Scalable infrastructure of web application using database server</h1></center>

<left><table class="tg">
<tbody>
  <tr>
    <td class="tg-0pky"><center><b>CI/CD</b></center></td>
    <td class="tg-0pky"><center><b>Jenkins</b></td>
    <td class="tg-0pky"><center><b>Version 2.41.1</b></center></td>
  </tr>
  <tr>
    <td class="tg-0pky"><center><b>Cloud</b></center></td>
    <td class="tg-0pky"><center><b>AWS</b></td>
    <td class="tg-0pky"><center><b></b></center></td>
  </tr>
  <tr>
    <td class="tg-0pky"><center><b>Infrastructure as Code</b></center></td>
    <td class="tg-0pky"><center><b>Terraform</b></center></td>
    <td class="tg-0pky"><center><b>AWS provider 5.15.x</b></center></td>
  </tr>
  <tr>
    <td class="tg-0pky"><center><b>AWS instance</b></center></td>
    <td class="tg-0pky"><center><b>Amazon Linux 2, t2.micro instance type</b></center></td>
    <td class="tg-0pky"><center><b>Auto Scaling Group</b></center></td>
    
  </tr>
  <tr>
    <td class="tg-0pky"><center><b>MySQL database server</b></center></td>
    <td class="tg-0pky"><center><b>Amazon RDS instance, db.t2.micro instance type</b></center></td>
    <td class="tg-0pky"><center><b>Allocated storage and max allocated storage set</b></center></td>
  </tr>
</tbody>
</table></left>

AWS instance, which hosts the web application, is created and able to scale in/out thanks to Auto Scaling Group solution in AWS public cloud.<br>
When the threshold of 500 MB RAM will be exceeded, ASG will create one new instance. Also the instance will be terminated, if the threshold<br> will be satisfied.
Servers are meant to connect with database server, which is Amazon RDS instance.<br>
What differs from the web application servers, database storage will be scaled up (vertically), up to 10 GB<br>

Application server(s) will access database server with 3306 port to communicate with the MySQL DB itself

Database credentials are gathered from Jenkins credential store, variable passed into the terraform apply -var $var...<br>
DNS name for Application Load Balancer will be taken from output after creation<br>

<h2> How will you achieve version control for your coding ? </h2>

Code versioning is done with Git, where all development is commited into developer branch.<br>
All changes are tagged with version number, which is additional metric helping with version tracking.<br>
When the code has no errors and the infrastructure plan is as desired, the code is merged into the main branch.<br>

<h2>What were the challenges did you face and how did you tackle them during this whole assignment ?</h2>

First and the main challenge is to choose the public cloud to deploy the infrastructure with.<br>
My choice from the "big three" of public clouds is Amazon Web Services.<br>
This is the best choice for the most demanding development, according to official rankings, AWS cloud is still the best choice in the market.<br>

Second problem is to choose the way the web application is going to be deployed.<br>
The task was meant to host the web application in scalable deployment, using application and database servers.
I decided to plan the infrastructure to deploy web application, hosted on my another GitHub repo (<a href="https://github.com/kamilzaborowski/webapp">WebApp</a>).<br>

Next, Amazon RDS is not able to create database on the start. To do so, we can open route outside of VPC to the machine and execute SQL query <br>
But the task disallow it and the only way is to access it internally. My idea is to provision single instance with mysql client installed to proceed with the SQL query execution.<br>
After this process, machine is meant to be destroyed.<br>

This idea helped me to solve case number 4. What should be the order of instances ?<br>
The order is:<br>
<b>- Database instance with all dependencies, with 3306 port opened</b><br>
<b>- EC2 instance to execute the SQL query with 3306 port </b><br>
<b>- Auto Scaling Group EC2 instance(s), performing CRUD operations to database</b><br>

The last challenge was to choose CI/CD tool to automate the deployment process<br>
It is safe to store credentials in on-premise server or vault, like AWS Secret Manager provided with Amazon's cloud.<br>
I decided to choose Jenkins. It is quite old tool written in Java, with special Groovy language,<br>
but still developed with great plugins still written and managed.<br>
Jenkins helps in versioning of the whole deployment in Git. Whole file is available in this repository<br>
Its main task is to perform SCM poll every 5 min (scheduled with crontab) and execute the code <br>
pulled from git repository, when new version of code will appear in main branch.<br>
