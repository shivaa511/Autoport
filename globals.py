import ConfigParser
import os
import paramiko
import socket
from github import Github
from cache import Cache
from threadpool import ThreadPool
from urlparse import urlparse

# Config Globals
# All global variables should be here
def init():
    # parse global data from config file
    config = ConfigParser.ConfigParser()
    config.read("./config.ini")

    configOptions = {}
    sections = config.sections()
    for section in sections:
        options = config.options(section)
        for option in options:
            try:
                configOptions[option] = config.get(section, option)
                if configOptions[option] == -1:
                    DebugPrint("skip: %s" % option)
            except:
                print("exception on %s!" % option)
                configOptions[option] = None

    # globals based on config file
    global jenkinsUrl
    global mavenPath
    global githubToken
    global hostname
    global configUsername
    global configPassword
    global configJenkinsUsername
    global configJenkinsKey
    global pathForTestResults
    global pathForBatchFiles
    global localPathForTestResults
    global localPathForBatchFiles
    global artifactsPathPrefix
    global threadPoolSize

    # user configuration globals that are supported by the user interface
    jenkinsUrl = configOptions['jenkinsurl']
    mavenPath = configOptions['mavenpath']
    githubToken = configOptions['githubtoken']
    hostname = configOptions['hostname']
    configUsername = configOptions['username']
    configPassword = configOptions['password']
    configJenkinsUsername = configOptions['jenkinsusername']
    configJenkinsKey = configOptions['autoportjenkinskey']
    pathForTestResults = configOptions['pathfortestresults']
    pathForBatchFiles = configOptions['pathforbatchfiles']
    localPathForTestResults = configOptions['localpathfortestresults']
    localPathForBatchFiles = configOptions['localpathforbatchfiles']
    artifactsPathPrefix = configOptions['artifactspathprefix']
    threadPoolSize = int(configOptions['threadpoolsize'])

    # globals not based on config file
    global github
    global cache
    global nodeLabels
    global nodeNames
    global nodeDetails
    global nodeUbuntu
    global nodeRHEL
    global sshClient
    global ftpClient
    global threadPool
    global localHostName
    global minRandom
    global maxRandom
    global localPathForListResults
    global localPathForConfig

    # need to use the token to be able to perform more requests per hour
    github = Github(githubToken)

    # used for caching repo data
    cache = Cache(github)
   
    # create pool of worker threads that query Jenkins for job completion 
    threadPool = ThreadPool(threadPoolSize)

    # get local hostname to append to job names
    localHostName = socket.gethostname()

    # set random number range for UUID
    minRandom = 100000
    maxRandom = 999999

    localPathForListResults="./data/list_results/"
    localPathForConfig="./data/config/"

    nodeLabels = []
    nodeNames = []
    nodeDetails = []
    nodeUbuntu = []
    nodeRHEL = []
