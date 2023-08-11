function setName(name) {
    console.log("my name is " + name);
    document.getElementsByTagName("h1")[0].innerHTML="manulife";
}

function getFlutterData() {
//request flutter to getData
    getData.postMessage("static/data.json");
}

function setFlutterData(d){
//for flutter to call
    document.getElementsByTagName("p")[0].innerHTML=JSON.stringify(d);
}