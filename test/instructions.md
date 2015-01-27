# interactive building of R results


- start shell within emacs
- go into ./test directory
- start docker container with current directory mounted

````
docker run -it -v $PWD:/home/jovyan/mount juliafinmetrix/jupyter bash
````
- go to mounted directory
- start R
- connect to R with `M-x ess-remote`

# building R results as batch job

- start shell within emacs
- go into ./test directory
- start docker container with current directory mounted
````
docker run -it -v $PWD:/home/jovyan/mount juliafinmetrix/jupyter bash
````
- run batch job
````
run(`docker run -t --rm -w /home/jovyan/mount -v $PWD:/home/jovyan/mount/ juliafinmetrix/jupyter bash R CMD BATCH --no-save --no-restore build/r_cop_funcs.R`)
````

# building R results as batch job from julia
