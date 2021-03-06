$sourceRoot = "E:\Source\"

$dependenciesPath = $sourceRoot + "sutekishop\Suteki.Shop\Dependencies\"

$castleCoreRoot = $sourceRoot + "Castle\Castle.Core"
$castleCoreOutput = $castleCoreRoot + "\build\NET40\Release\Library\bin"

$windsorRoot = $sourceRoot + "Castle\Castle.InversionOfControl"
$windsorBuildOutput = $windsorRoot + "\build\NET40\Release\Library\bin"

$nhibernateRoot = $sourceRoot + "nhibernate"
$nhibernateBuildOutput = $nhibernateRoot + "\trunk\nhibernate\build\NHibernate-3.0.0.Alpha3-debug\bin\net-3.5"
$nhibernateLibFolder = $nhibernateRoot + "\trunk\nhibernate\lib\net\3.5"

$nhibernateFacilityRoot = $sourceRoot + "Castle\Castle.Facilities.NHibernateIntegration"
$nhibernateFacitliyBuildOutput = $nhibernateFacilityRoot + "\build\NET40\Release\bin"
$nhibernateFacilityLibFolder = $nhibernateFacilityRoot + "\lib\net40"

$windsorRoot

# get latest Castle Core source
Set-Location -Path $castleCoreRoot
git reset --hard origin/master
git pull

# build Castle Core
& ($castleCoreRoot + "\buildscripts\build.cmd") "NET40" "BuildProject"

# get latest NHibernate source
Set-Location -Path $nhibernateRoot
svn revert .
# svn update .

# copy the castle core assemblies into the NHibernate libs folder
copy-item ($castleCoreOutput + "\Castle.Core.dll") -destination $nhibernateLibFolder

# build NHibernate
Set-Location -Path ($nhibernateRoot + "\trunk\nhibernate")
NAnt -D:with.core.only=true

# get latest Windsor source
Set-Location -Path $windsorRoot
git reset --hard origin/master
git pull

# build Windsor
& ($windsorRoot + "\buildscripts\build.cmd") "NET40" "BuildProject"

# get latest NHibernate Facility source
Set-Location -Path $nhibernateFacilityRoot
git reset --hard origin/master
git pull

# copy the NHibernate assemblies into the NHibernate Facility libs folder
copy-item ($nhibernateBuildOutput + "\NHibernate.dll") -destination $nhibernateFacilityLibFolder
copy-item ($nhibernateBuildOutput + "\NHibernate.ByteCode.Castle.dll") -destination $nhibernateFacilityLibFolder

# build NHibernate Facility
& ($nhibernateFacilityRoot + "\buildscripts\build.cmd") "NET40" "BuildProject"
