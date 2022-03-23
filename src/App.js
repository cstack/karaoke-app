import React from 'react';
import logo from './logo.svg';
import './water.css';
import './App.css';
import SONGS from './songs.json';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      suggestedSong: null,
      noMatchingSong: false,
      groupSize: 1,
      decade: "",
    };
  }
  render() {
    return (
    <div className="App">
      <div className="Filters">
        <GroupSizePicker value={this.state.groupSize} onChange={(value) => this.setState({groupSize: value}) } />
      </div>
      <NewSongButton onClick={() => { this.pickNewSong() }}>Pick New Song</NewSongButton>
      <Song song={this.state.suggestedSong} noMatchingSong={this.state.noMatchingSong} />
    </div>
  );
  }

  randomSong() {
    const filteredSongs = SONGS.filter((song) => {
      return song.number_of_singers == this.state.groupSize;
    });
    return filteredSongs[Math.floor(Math.random()*filteredSongs.length)];
  }

  pickNewSong() {
    const song = this.randomSong();
    this.setState({
      suggestedSong: this.randomSong(),
      noMatchingSong: false,
    });
    if (!song) {
      this.setState({
        noMatchingSong: true,
      });
    }
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

class GroupSizePicker extends React.Component {
  render() {
    return (
      <select value={this.props.value} onChange={this.handleChange.bind(this)}>
        <option value="1">Solo</option>
        <option value="2">Duet</option>
        <option value="3">Group</option>
      </select>
    );
  }

  handleChange(event) {
    this.props.onChange(event.target.value);
  }
}

class Song extends React.Component {
  render() {
    if (this.props.noMatchingSong) {
      return (
        <div className="Song">
          <h1>No Songs Match Filters</h1>
        </div>
      );
    }
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
