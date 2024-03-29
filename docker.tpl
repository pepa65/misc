# Use:  docker inspect --format "$(<docker.tpl)" #container_id
# Define function:
# di(){ [[ ! $1 ]] && echo "Need docker container_id to inspect" && return || docker inspect --format "$(grep -v '^#' ~/git/misc/docker.tpl)" "$1";}
docker run \
  --name {{printf "%q" .Name}} \
    {{- with .HostConfig}}
        {{- if .Privileged}}
  --privileged \
        {{- end}}
        {{- if .AutoRemove}}
  --rm \
        {{- end}}
        {{- if .Runtime}}
  --runtime {{printf "%q" .Runtime}} \
        {{- end}}
        {{- range $b := .Binds}}
  --volume {{printf "%q" $b}} \
        {{- end}}
        {{- range $v := .VolumesFrom}}
  --volumes-from {{printf "%q" $v}} \
        {{- end}}
        {{- range $l := .Links}}
  --link {{printf "%q" $l}} \
        {{- end}}
        {{- if .PublishAllPorts}}
  --publish-all \
        {{- end}}
        {{- if .UTSMode}}
  --uts {{printf "%q" .UTSMode}} \
        {{- end}}
        {{- with .LogConfig}}
  --log-driver {{printf "%q" .Type}} \
            {{- range $o, $v := .Config}}
  --log-opt {{$o}}={{printf "%q" $v}} \
            {{- end}}
        {{- end}}
        {{- with .RestartPolicy}}
  --restart "{{.Name -}}
            {{- if eq .Name "on-failure"}}:{{.MaximumRetryCount}}
            {{- end}}" \
        {{- end}}
        {{- range $e := .ExtraHosts}}
  --add-host {{printf "%q" $e}} \
        {{- end}}
        {{- range $v := .CapAdd}}
  --cap-add {{printf "%q" $v}} \
        {{- end}}
        {{- range $v := .CapDrop}}
  --cap-drop {{printf "%q" $v}} \
        {{- end}}
        {{- range $d := .Devices}}
  --device {{printf "%q" (index $d).PathOnHost}}:{{printf "%q" (index $d).PathInContainer}}:{{(index $d).CgroupPermissions}} \
        {{- end}}
    {{- end}}
    {{- with .NetworkSettings -}}
        {{- range $p, $conf := .Ports}}
            {{- with $conf}}
  --publish "
                {{- if $h := (index $conf 0).HostIp}}{{$h}}:
                {{- end}}
                {{- (index $conf 0).HostPort}}:{{$p}}" \
            {{- end}}
        {{- end}}
        {{- range $n, $conf := .Networks}}
            {{- with $conf}}
  --network {{printf "%q" $n}} \
                {{- range $a := $conf.Aliases}}
  --network-alias {{printf "%q" $a}} \
                {{- end}}
            {{- end}}
        {{- end}}
    {{- end}}
    {{- with .Config}}
        {{- if .Hostname}}
  --hostname {{printf "%q" .Hostname}} \
        {{- end}}
        {{- if .Domainname}}
  --domainname {{printf "%q" .Domainname}} \
        {{- end}}
        {{- range $p, $conf := .ExposedPorts}}
  --expose {{printf "%q" $p}} \
        {{- end}}
        {{- range $e := .Env}}
  --env {{printf "%q" $e}} \
        {{- end}}
        {{- range $l, $v := .Labels}}
  --label {{printf "%q" $l}}={{printf "%q" $v}} \
        {{- end}}
    {{- if not (or .AttachStdin  (or .AttachStdout .AttachStderr))}}
  --detach \
    {{- end}}
    {{- if .AttachStdin}}
  --attach stdin \
    {{- end}}
    {{- if .AttachStdout}}
  --attach stdout \
    {{- end}}
    {{- if .AttachStderr}}
  --attach stderr \
    {{- end}}
    {{- if .Tty}}
  --tty \
    {{- end}}
    {{- if .OpenStdin}}
  --interactive \
    {{- end}}
    {{- if .Entrypoint}}
{{- /* Since the entry point cannot be overridden from the command line with an array of size over 1,
       we are fine assuming the default value in such a case. */ -}}
        {{- if eq (len .Entrypoint) 1 }}
  --entrypoint "
            {{- range $i, $v := .Entrypoint}}
                {{- if $i}} {{end}}
                {{- $v}}
            {{- end}}" \
        {{- end}}
    {{- end}}
  {{printf "%q" .Image}} \
  {{range .Cmd}}{{printf "%q " .}}{{- end}}
{{- end}}
