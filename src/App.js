import React from 'react';
import './water.css';
import './App.css';
import SONGS from './songs.json';

const DECADE_MAP = {
  "70s": 1970,
  "80s": 1980,
  "90s": 1990,
  "00s": 2000,
  "10s": 2010,
  "20s": 2020,
};

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
        <DecadePicker value={this.state.decade} onChange={(value) => this.setState({decade: value}) } />
      </div>
      <NewSongButton onClick={() => { this.pickNewSong() }}>Pick New Song</NewSongButton>
      <Song song={this.state.suggestedSong} noMatchingSong={this.state.noMatchingSong} />
    </div>
  );
  }

  randomSong() {
    const filteredSongs = SONGS.filter((song) => {
      return this.matchNumberOfSingers(song) &&
        this.matchDecade(song);
    });
    return filteredSongs[Math.floor(Math.random()*filteredSongs.length)];
  }

  matchNumberOfSingers(song) {
    return song.number_of_singers === this.state.groupSize.toString();
  }

  matchDecade(song) {
    if (this.state.decade === "") {
      return true;
    } else {
      const decadeStart = DECADE_MAP[this.state.decade];
      return song.year >= decadeStart && song.year < (decadeStart + 10);
    }
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
      </select>
    );
  }

  handleChange(event) {
    this.props.onChange(event.target.value);
  }
}

class DecadePicker extends React.Component {
  render() {
    return (
      <select value={this.props.value} onChange={this.handleChange.bind(this)}>
        <option value="">Any Decade</option>
        <option value="70s">70s</option>
        <option value="80s">80s</option>
        <option value="90s">90s</option>
        <option value="00s">00s</option>
        <option value="10s">10s</option>
        <option value="20s">20s</option>
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
          <h2>{song.artist}</h2>
          <h3>{song.year}</h3>
        </div>
      );
    } else {
      return null;
    }
  }
}

export default App;
