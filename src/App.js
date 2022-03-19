import React from 'react';
import logo from './logo.svg';
import './App.css';
import SONGS from './songs.json';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      suggestedSong: null,
      // suggestedSong: this.randomSong(),
    };
  }
  render() {
    return (
    <div className="App">
      <NewSongButton onClick={() => { this.pickNewSong() }}>Pick New Song</NewSongButton>
      <Song song={this.state.suggestedSong} />
    </div>
  );
  }

  randomSong() {
    return SONGS[Math.floor(Math.random()*SONGS.length)];
  }

  pickNewSong() {
    this.setState({
      suggestedSong: this.randomSong(),
    });
  }
}

class NewSongButton extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
    };
  }
  render() {
    return (
      <button className="NewSongButton" onClick={this.props.onClick}>Pick New Song</button>
    );
  }

  pickNewSong() {
    const song = SONGS[Math.floor(Math.random()*SONGS.length)];
    this.setState({
      suggestedSong: song,
    });
  }
}

class Song extends React.Component {
  render() {
    const song = this.props.song;
    if (song) {
      return (
        <div className="Song">
          <h1>{song.title}</h1>
          <h3>by</h3>
          <h2>{song.artist}</h2>
        </div>
      );
    } else {
      return null;
    }
  }
}

export default App;
