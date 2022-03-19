import React from 'react';
import logo from './logo.svg';
import './App.css';
import Song from './Song.js';
import SONGS from './songs.json';

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
