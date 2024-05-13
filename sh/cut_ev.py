from obspy.core.stream import read
from obspy.core.utcdatetime import UTCDateTime
from obspy.taup import TauPyModel
from obspy.geodetics.base import locations2degrees
import sys

eq_time = sys.argv[1]
model = TauPyModel(model='iasp91')
t_eq = UTCDateTime(eq_time)
evla = float(sys.argv[2])
evlo = float(sys.argv[3])
evdp = float(sys.argv[4])

st_Z = read('./removed2/SS.*.GPZ.D.'+str(t_eq.year)+'.'+f"{t_eq.julday:03}"+'.*.SAC.removed')
st_E = read('./removed2/SS.*.GPE.D.'+str(t_eq.year)+'.'+f"{t_eq.julday:03}"+'.*.SAC.removed')
st_N = read('./removed2/SS.*.GPN.D.'+str(t_eq.year)+'.'+f"{t_eq.julday:03}"+'.*.SAC.removed')

out_dir = './EQ/' + eq_time.replace(':','-') + '/'
# cut event 
Z = st_Z.copy()
E = st_E.copy()
N = st_N.copy()
Z.filter('bandpass',freqmin = 0.3,freqmax = 5)
E.filter('bandpass',freqmin = 0.3,freqmax = 5)
N.filter('bandpass',freqmin = 0.3,freqmax = 5)
i = 0
for st in st_Z:
    stla = st.stats.sac.stla
    stlo = st.stats.sac.stlo
    st.stats.sac.evla = evla
    st.stats.sac.evlo = evlo
    dist = locations2degrees(evla,evlo,stla,stlo)
    arrival = model.get_travel_times(source_depth_in_km=evdp,distance_in_degree=dist,phase_list=["P"])
    t1 = t_eq + arrival[0].time - 5
    t2 = t_eq + arrival[0].time + 75
    Z[i].trim(t1,t2)
    N[i].trim(t1,t2)
    E[i].trim(t1,t2)
    Z[i].stats.sac.evla = evla
    Z[i].stats.sac.evlo = evlo
    Z[i].stats.sac.evdp = 10
    Z[i].stats.sac.t0 = arrival[0].time + t_eq.hour*60*60+t_eq.minute*60+t_eq.second
    Z[i].stats.sac.kuser0 = 'P'
    Z[i].stats.sac.cmpinc = 180
    Z[i].stats.sac.cmpaz = 0
    E[i].stats.sac.evla = evla
    E[i].stats.sac.evlo = evlo
    E[i].stats.sac.evdp = 10
    E[i].stats.sac.t0 = arrival[0].time + t_eq.hour*60*60+t_eq.minute*60+t_eq.second
    E[i].stats.sac.kuser0 = 'P'
    E[i].stats.sac.cmpinc = 90.
    E[i].stats.sac.cmpaz = 90.
    N[i].stats.sac.evla = evla
    N[i].stats.sac.evlo = evlo
    N[i].stats.sac.evdp = 10
    N[i].stats.sac.t0 = arrival[0].time + t_eq.hour*60*60+t_eq.minute*60+t_eq.second
    N[i].stats.sac.kuser0 = 'P'
    N[i].stats.sac.cmpaz = 0.
    N[i].stats.sac.cmpinc = 90.
    Z[i].write(out_dir+Z[i].stats.station+'.Z.SAC.Pcut_high',format='SAC')
    N[i].write(out_dir+Z[i].stats.station+'.N.SAC.Pcut_high',format='SAC')
    E[i].write(out_dir+Z[i].stats.station+'.E.SAC.Pcut_high',format='SAC')
    i = i + 1
print(t_eq,'done')
