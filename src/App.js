import React from 'react';
import logo from './logo.svg';
import './App.css';
import Song from './Song.js';

const SONGS = [
{ title: "Truth Hurts", artist: "Lizzo", },
{ title: "Dangerous Woman", artist: "Ariana Grande", },
{ title: "Oops...I Did It Again", artist: "Britney Spears", },
{ title: "Mr. Brightside", artist: "The Killers", },
{ title: "Don't Speak", artist: "No Doubt", },
{ title: "Make You Feel My Love", artist: "Adele", },
{ title: "Love Song", artist: "Sara Bareilles", },
{ title: "Since U Been Gone", artist: "Kelly Clarkson", },
{ title: "Livin' on a Prayer", artist: "Bon Jovi", },
{ title: "Ironic", artist: "Alanis Morrisette", },
{ title: "A Thousand Years", artist: "Christina Perri", },
{ title: "Jump Around", artist: "House of Pain", },
{ title: "Just the Way You Are", artist: "Bruno Mars", },
{ title: "...Baby One More Time", artist: "Britney Spears", },
{ title: "He Wasn't Man Enough for Me", artist: "Toni Braxton", },
{ title: "If I Ain't Got You", artist: "Alicia Keys", },
{ title: "Like a Prayer", artist: "Madonna", },
{ title: "U Remind Me", artist: "Usher ", },
{ title: "Genie In a Bottle", artist: "Christina Aguilera", },
{ title: "Back to Black", artist: "Amy Winehouse", },
{ title: "Bleeding Love", artist: "Leona Lewis", },
{ title: "Me, Myself, and I", artist: "Beyoncé", },
{ title: "Someone Like You", artist: "Adele", },
{ title: "Torn", artist: "Natalie Imbruglia", },
{ title: "A Thousand Miles", artist: "Vanessa Carlton", },
{ title: "Unwritten", artist: "Natasha Bedingfield", },
{ title: "She Bangs", artist: "Ricky Martin", },
{ title: "We Can't Stop", artist: "Miley Cyrus", },
{ title: "Always Be My Baby", artist: "Mariah Carey", },
{ title: "Wonderwall", artist: "Oasis", },
];

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      suggestedSong: null,
    };
  }
  render() {
    return (
    <div className="App">
      <button onClick={() => { this.pickNewSong() }}>Pick New Song</button>
      <Song song={this.state.suggestedSong} />
    </div>
  );
  }

  pickNewSong() {
    const song = SONGS[Math.floor(Math.random()*SONGS.length)];
    this.setState({
      suggestedSong: song,
    });
  }
}

export default App;
