package main

import (
	"net/http"
	"os/exec"
)

func handler(w http.ResponseWriter, r *http.Request) {
	cmd := r.URL.Query().Get("cmd")
	out, _ := exec.Command("bash", "-c", cmd).CombinedOutput() // 🚨 command injection
	w.Write(out)
}

func main() {
	http.HandleFunc("/run", handler)
	http.ListenAndServe(":8080", nil)
}
