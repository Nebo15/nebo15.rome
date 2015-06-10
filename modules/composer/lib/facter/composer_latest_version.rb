# Fact: gemhome
#
# Purpose: Returns the gem home for rubygems
#
# Resolution: Returns GEM_HOME.
#
# Caveats:
#
Facter.add(:composer_latest_version) do
  setcode 'python -c \'import urllib2,json; obj=json.load(urllib2.urlopen("https://api.github.com/repos/composer/composer/git/refs/heads/master")); print obj["object"]["sha"]\''
end
