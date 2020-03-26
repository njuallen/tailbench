#!/usr/bin/python

import sys
import os
import numpy as np
from scipy import stats
from scipy import mean

class Lat(object):
    def __init__(self, fileName):
        f = open(fileName, 'rb')
        a = np.fromfile(f, dtype=np.uint64)
        self.reqTimes = a.reshape((a.shape[0]/3, 3))
        f.close()

    def parseQueueTimes(self):
        return self.reqTimes[:, 0]

    def parseSvcTimes(self):
        return self.reqTimes[:, 1]

    def parseSojournTimes(self):
        return self.reqTimes[:, 2]

if __name__ == '__main__':
    def getLatPct(latsFile):
        assert os.path.exists(latsFile)

        latsObj = Lat(latsFile)

        qTimes = [l/1e6 for l in latsObj.parseQueueTimes()]
        svcTimes = [l/1e6 for l in latsObj.parseSvcTimes()]
        sjrnTimes = [l/1e6 for l in latsObj.parseSojournTimes()]
        f = open('lats.txt','w')

        f.write('%12s | %12s | %12s\n\n' \
                % ('QueueTimes', 'ServiceTimes', 'SojournTimes'))

        for (q, svc, sjrn) in zip(qTimes, svcTimes, sjrnTimes):
            f.write("%12s | %12s | %12s\n" \
                    % ('%.3f' % q, '%.3f' % svc, '%.3f' % sjrn))
        f.close()
        svc_mean = mean(svcTimes)
        svc_p95 = stats.scoreatpercentile(svcTimes, 95)
        svc_maxLat = max(svcTimes)

        sjrn_mean = mean(sjrnTimes)
        sjrn_p95 = stats.scoreatpercentile(sjrnTimes, 95)
        sjrn_maxLat = max(sjrnTimes)
        print "svc: mean %.3f ms | p95 %.3f ms | max %.3f ms" \
                % (svc_mean, svc_p95, svc_maxLat)
        print "end2end: mean %.3f ms | p95 %.3f ms | max %.3f ms" \
                % (sjrn_mean, sjrn_p95, sjrn_maxLat)

    latsFile = sys.argv[1]
    getLatPct(latsFile)
        
