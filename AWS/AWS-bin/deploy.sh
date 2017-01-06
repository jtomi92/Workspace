#  sed -i -e 's/\r$//' /home/ec2-user/deploy.sh
DESTINATION="/var/lib/tomcat8/webapps"
SOURCE="/home/ec2-user"

if [ $# -lt 2 ]; then
  echo 1>&2 "$0: not enough arguments"
  exit 2
elif [ $# -gt 2 ]; then
  echo 1>&2 "$0: too many arguments"
  exit 2
fi

echo DEPLOY [STARTING]

echo rm -rf $DESTINATION/$2
sudo rm -rf $DESTINATION/$2

echo mkdir $DESTINATION/$2
sudo mkdir $DESTINATION/$2

echo cp $SOURCE/$1 $DESTINATION/$2/
sudo cp $SOURCE/$1 $DESTINATION/$2/

echo unzip -qq $DESTINATION/$2/$1 -d $DESTINATION/$2/
sudo unzip -qq $DESTINATION/$2/$1 -d $DESTINATION/$2/

echo chmod 777 $DESTINATION/$2
sudo chmod 777 $DESTINATION/$2

echo rm -f $SOURCE/$1
sudo rm -f $SOURCE/$1

echo rm -f $DESTINATION/$2/$1
sudo rm -f $DESTINATION/$2/$1

sudo service tomcat8 restart

echo DEPLOY [SUCCESS]