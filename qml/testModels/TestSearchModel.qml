import QtQuick 2.3

ListModel {
    id: testModel

    ListElement {
        name: "Labios Rotos"
        artist: "Zoe"
        picture: "zoe"
        length: "3:40"
        kbps: 192
    }

    ListElement {
        name: "Yesterday"
        artist: "The Beatles"
        picture: "beatles"
        length: "2:58"
        kbps: 128
    }

    ListElement {
        name: "Another one bites the dust"
        artist: "Queen"
        picture: "queen"
        length: "3:14"
        kbps: 320
    }

    ListElement {
        name: "hips don't lie"
        artist: "Shakira"
        picture: "shakira"
        length: "3:22"
        kbps: 98
    }

    ListElement {
        name: "Hotel Room Service"
        artist: "Pitbull"
        picture: "pitbull"
        length: "4:15"
        kbps: 64
    }

    ListElement {
        name: "Song Name"
        artist: "Fake"
        picture: "crazystuff"
        length: "3:10"
        kbps: 64
    }
}
