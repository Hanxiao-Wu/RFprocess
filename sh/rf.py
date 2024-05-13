from obspy.core.stream import read
from seispy import decon
import sys

ev=sys.argv[1]
R = read(ev+'/*.R.SAC.Pcut')
Z = read(ev+'/*.Z.SAC.Pcut')

Gaussian_width = 2.5 # 5.
nbumps = 200
phase_delay = 5.
min_error = 0.001
dt = R[0].stats.delta
rf = R.copy()

i = 0
for st in R:
    R_tr = R[i].data
    Z_tr = Z.select(station=R[i].stats.station)[0].data
    PRF_R,RMS,it = decon.deconit(R_tr,Z_tr,dt,R_tr.shape[0],phase_delay,Gaussian_width,nbumps,min_error)
    rf[i].data = PRF_R
    rf[i].stats.channel = 'PRF_R'
    rf[i].stats.starttime = rf[i].stats.starttime - phase_delay
    rf[i].stats.sac.user0 = Gaussian_width
    rf[i].stats.sac.user1 = (1-RMS[-1])*100
    rf[i].write(ev+'/'+rf[i].stats.station+'.Prf',format='SAC')
    i = i + 1

print('done:',ev)
