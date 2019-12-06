from concurrent.futures import ThreadPoolExecutor as PoolExecutor
import multiprocessing as mp
import time
import http.client
import socket

"""
The following code is used to stress test our site. Uses parallel HTTP connections to continuously attempt GETing the index page.
"""

class parallelRequestsLoader:
    def getURL(self,url):
        port=80
        connection = http.client.HTTPConnection(url, port,timeout=5)
        connection.request('GET', url)
        response = connection.getresponse()
        print("Server response: " + str(response.status))
        #list objects for later usage with comparison.
        connection.close()
loader = parallelRequestsLoader()
#instantantiate an object of class RequestsLoader
debugLevel = 0
lazyList = []
numberOfRequests = 10000
#how many requests we want to make at once
start = 0
#can be changed to print out response
if debugLevel == 1:
    loader.getURL("SeniorDesignProject2ALB-790864702.us-west-2.elb.amazonaws.com")

while start < numberOfRequests:
    lazyList.append("SeniorDesignProject2ALB-790864702.us-west-2.elb.amazonaws.com")
    print("%d of %d" % (start,numberOfRequests))
    start = start+1
#generate a list of 10,000 of the same IP to be used for multiprocessing
start_time = time.time()
with PoolExecutor(max_workers=20) as executor:
    for _ in executor.map(loader.getURL,lazyList):
        pass
print("--- %s seconds ---" % (time.time() - start_time))    
