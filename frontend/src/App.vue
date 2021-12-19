<template>
  <img alt="Vue logo" src="./assets/logo.png">
  <NodeCall/>
</template>

<script>
import NodeCall from './components/NodeCall';
export default {
  name: 'App',
  components: {
    NodeCall
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
