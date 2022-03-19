import React from 'react';

class Song extends React.Component {
  render() {
    const song = this.props.song;
    if (song) {
      return (
        <React.Fragment>
          <h1>{song.title}</h1>
          <h3>by</h3>
          <h2>{song.artist}</h2>
        </React.Fragment>
      );
    } else {
      return null;
    }
  }
}

export default Song;
