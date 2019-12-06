from concurrent.futures import ThreadPoolExecutor as PoolExecutor
import multiprocessing as mp
import time
import http.client
import socket
class parallelRequestsLoader:
    def getURL(self,url,port):
        connection = http.client.HTTPConnection(url, port,timeout=5)
        connection.request('GET', url)
        #is head fine to use? will save some time compared to get
        response = connection.getresponse()
        #find prevents us from needing to catch errors. we don't need to find or index the string "disney" we simply need to know if it exists.
        print("Server response: " + str(response.status))
        #list objects for later usage with comparison.
        connection.close()
loader = parallelRequestsLoader()
loader.getURL("http://demo-eu-alb-1939214429.eu-west-2.elb.amazonaws.com/",80)
start_time = time.time()
with PoolExecutor(max_workers=20) as executor:
    for _ in executor.map(loader.getURL("http://demo-eu-alb-1939214429.eu-west-2.elb.amazonaws.com/",80)
,100000):
        pass
print("--- %s seconds ---" % (time.time() - start_time))    
