require 'java'

# Workaround for GitChangeSet bug,
# getAuthor() doesn't set author's email because;
# https://github.com/jenkinsci/git-plugin/blob/git-1.1.26/src/main/java/hudson/plugins/git/GitChangeSet.java#L274
# > if (fixEmpty(csAuthorEmail) != null && user.getProperty(Mailer.UserProperty.class)==null) {
# user.getProperty(...) always return not null.

begin
  import 'hudson.plugins.git.GitChangeSet'
  class Java::HudsonPluginsGit::GitChangeSet
    field_reader :authorEmail
    alias author_email authorEmail
  end
rescue NameError
  # do nothing
end
