# jb-solaredge-docker

This is still heavily a work in progress to better understand the
process to capture data from the SolarEdge inverters using the pacakges from
[jbuehl/solaredge](https://github.com/jbuehl/solaredge).

## Lessons Learned

* se2state.py requires an existing initialized json file for output. I think I
lucked into getting one using the process gleaned from jbuehl/solaredge#107.
You take the first output file `output.json` from `tcpdump -i eno2 -s 65535 -w - 'tcp and host 10.1.10.199'  | python /solaredge/semonitor.py -vvv | tee /solaredge/data/output.json | python /solaredge/conversion/se2state.py -i /solaredge/data/output.json -o /solaredge/data/solar.json`
and copy it to `solar.json`. I think you only have to do this once but YMMV.
