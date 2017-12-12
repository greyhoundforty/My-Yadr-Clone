
export VIRTUALENVWRAPPER_PYTHON=/usr/local/opt/python/libexec/bin/python
export WORKON_HOME=$HOME/.virtualEnvs
export PROJECT_HOME=$HOME/Projects
if [[ -f /usr/local/bin/virtualenvwrapper.sh ]];then
   source /usr/local/bin/virtualenvwrapper.sh
fi
