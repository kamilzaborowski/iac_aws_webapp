<center><h1>Scalable infrastructure of web application using database server</h1></center>

<left><table class="tg">
<tbody>
  <tr>
    <td class="tg-0pky"><center><b>Cloud</b></center></td>
    <td class="tg-0pky"><center><b>AWS</b></td>
  </tr>
  <tr>
    <td class="tg-0pky"><center><b>Infrastructure as Code</b></center></td>
    <td class="tg-0pky"><center><b>Terraform</b></center></td>
  </tr>
  <tr>
    <td class="tg-0pky"><center><b>AWS instance</b></center></td>
    <td class="tg-0pky"><center><b>Amazon Linux 2, t2.micro instance type</b></center></td>
  </tr>
  <tr>
    <td class="tg-0pky"><center><b>Database server</b></center></td>
    <td class="tg-0pky"><center><b>Amazon RDS instance, db.t2.micro instance type</b></center></td>
  </tr>
</tbody>
</table></left>

AWS instance, which hosts the web application, is created and able to scale in/out thanks to Auto Scaling Group solution in AWS public cloud.<br>
When the threshold of 500 MB RAM will be exceeded, ASG will create one new instance. Also the instance will be terminated, if the threshold<br> will be satisfied.
Servers are meant to connect with database server, which is Amazon RDS instance.<br>
What differs from the web application servers, database storage will be scaled up (vertically), up to 10 GB<br>

Application server(s) will access database server with 3306 port to communicate with the MySQL DB itself

Database credentials are gathered from AWS Secret Manager.
DNS name for Application Load Balancer

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
I decided to plan the infrastructure to deploy, which I host on GitHub (<a href="https://github.com/kamilzaborowski/webapp">WebApp</a>).<br>
The code is meant to be deployed from S3 bucket directly to the 

