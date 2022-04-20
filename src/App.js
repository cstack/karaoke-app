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
      maxLength: "",
    };
  }
  render() {
    return (
    <div className="App">
      <div className="Filters">
        <GroupSizePicker value={this.state.groupSize} onChange={(value) => this.setState({groupSize: value}) } />
        <DecadePicker value={this.state.decade} onChange={(value) => this.setState({decade: value}) } />
        <LengthPicker value={this.state.maxLength} onChange={(value) => this.setState({maxLength: value}) } />
      </div>
      <NewSongButton onClick={() => { this.pickNewSong() }}>Pick New Song</NewSongButton>
      <Song song={this.state.suggestedSong} noMatchingSong={this.state.noMatchingSong} />
    </div>
  );
  }

  randomSong() {
    const filteredSongs = SONGS.filter((song) => {
      return this.matchNumberOfSingers(song) &&
        this.matchDecade(song) &&
        this.matchLength(song);
    });
    return filteredSongs[Math.floor(Math.random()*filteredSongs.length)];
  }

  matchNumberOfSingers(song) {
    if (this.state.groupSize === "") {
      return true;
    }
    return song.number_of_singers === this.state.groupSize;
  }

  matchDecade(song) {
    if (this.state.decade === "") {
      return true;
    } else {
      const decadeStart = DECADE_MAP[this.state.decade];
      return song.year >= decadeStart && song.year < (decadeStart + 10);
    }
  }

  matchLength(song) {
    if (this.state.maxLength === "") {
      return true;
    } else {
      const maxMinutes = parseInt(this.state.maxLength);
      const maxMs = maxMinutes * 60 * 1000;
      return song.duration_ms < maxMs;
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
        <option value="">All</option>
      </select>
    );
  }

  handleChange(event) {
    const rawValue = event.target.value;
    const value = rawValue === "" ? "" : parseInt(rawValue);
    this.props.onChange(value);
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

class LengthPicker extends React.Component {
  render() {
    return (
      <select value={this.props.value} onChange={this.handleChange.bind(this)}>
        <option value="">Any Length</option>
        <option value="3">&lt; 3 minutes</option>
        <option value="4">&lt; 4 minutes</option>
        <option value="5">&lt; 5 minutes</option>
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
          <div class="SongTitle">{song.title}</div>
          <div className="SongArtist">{song.artist}</div>
          <div className="SongDetails">{song.year} • {this.formatDuration(song.duration_ms)}</div>
          <SongImage value={song.image_url} />
          <Lyrics value={song.lyrics} />
        </div>
      );
    } else {
      return null;
    }
  }

  formatDuration(durationMs) {
    const durationSeconds = Math.floor(durationMs / 1000);
    const minutes = Math.floor(durationSeconds / 60);
    const seconds = durationSeconds % 60;
    return `${minutes}:${seconds.toString().padStart(2, "0")}`;
  }
}

class SongImage extends React.Component {
  render() {
    if (this.props.value) {
      return (
        <img className="SongImage" src={this.props.value} />
      );
    } else {
      return null;
    }
  }

  formatDuration(durationMs) {
    const durationSeconds = Math.floor(durationMs / 1000);
    const minutes = Math.floor(durationSeconds / 60);
    const seconds = durationSeconds % 60;
    return `${minutes}:${seconds.toString().padStart(2, "0")}`;
  }
}

class Lyrics extends React.Component {
  render() {
    if (this.props.value) {
      const lines = this.props.value.split("\n").map((line) => {
        return <p>{line}</p>;
      })
      return (
        <div className="Lyrics">{lines}</div>
      );
    } else {
      return null;
    }
  }

  formatDuration(durationMs) {
    const durationSeconds = Math.floor(durationMs / 1000);
    const minutes = Math.floor(durationSeconds / 60);
    const seconds = durationSeconds % 60;
    return `${minutes}:${seconds.toString().padStart(2, "0")}`;
  }
}

export default App;
