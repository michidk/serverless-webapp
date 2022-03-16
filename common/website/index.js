'use strict';

async function analyze(input) {
    let response = await fetch(`${BACKEND_API}/analyze?input=${btoa(input)}`);
    let data = await response.json();
    return data;
}

async function submit() {
    let input = document.getElementById("input").value;

    let data = await analyze(input);
    console.log(data);

    let table = document.getElementById("table");
    table.replaceChildren();

    for (const [key, value] of Object.entries(data)) {
        console.log(key, value);

        let tr = document.createElement('tr');
        let td1 = document.createElement('td');
        td1.innerText = key;
        tr.appendChild(td1);
        let td2 = document.createElement('td');
        td2.innerText = value;
        tr.appendChild(td2);
        table.appendChild(tr);
    }
}

document.addEventListener('DOMContentLoaded', submit);
