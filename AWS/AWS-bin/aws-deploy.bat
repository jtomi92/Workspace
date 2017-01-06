@Echo off

if [%1]==[] (
	exit /b
)

if %1 == jtech-rest (
	set SOURCE=C:\Users\tjozsa\Desktop\Workspace\Projects\workspace\branches\Applications\WebService\1.0\jtech-servlet-logic\target\jtech-rest.war
	pscp -r -v %SOURCE% aws-cloud:/home/ec2-user/ 
	plink -v aws-cloud /home/ec2-user/deploy.sh jtech-rest.war jtech-rest
)

