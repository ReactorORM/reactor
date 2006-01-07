rmdir /S /Q "C:\Inetpub\Reactor For ColdFusion\distribute"
mkdir "C:\Inetpub\Reactor For ColdFusion\distribute"

cd c:\Program Files\Subversion\bin\

svn export svn://alagad.com/reactor/trunk/reactor "C:\Inetpub\Reactor For ColdFusion\distribute\Reactor" --force
svn export svn://alagad.com/reactor/trunk/ReactorSamples "C:\Inetpub\Reactor For ColdFusion\distribute\ReactorSamples" --force
svn export svn://alagad.com/reactor/trunk/Documentation "C:\Inetpub\Reactor For ColdFusion\distribute\Documentation" --force

echo Reactor Version Information > "C:\Inetpub\Reactor For ColdFusion\distribute\version.txt"
echo This is zip file contains an alpha version of Reactor 1.0.  For the specific build number, see the revision number below. >> "C:\Inetpub\Reactor For ColdFusion\distribute\version.txt"
echo --------------------------- >> "C:\Inetpub\Reactor For ColdFusion\distribute\version.txt"

svn info svn://alagad.com/reactor >> "C:\Inetpub\Reactor For ColdFusion\distribute\version.txt"


