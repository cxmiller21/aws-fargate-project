<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "NodeCall",
  props: {},
  data() {
    return {
      msg: "",
      loading: true,
      errored: false,
    };
  },
  mounted() {
    const fargateNodeIP = '' // update with public fargate node server ip address
    const nodeIpAddress = fargateNodeIP ? fargateNodeIP : 'localhost'
    axios
      .get(`http://${nodeIpAddress}:3000/getData`)
      .then((resp) => resp.data)
      .then((data) => {
        this.msg = data.msg;
      })
      .catch((error) => {
        console.log(error);
        this.errored = true;
      })
      .finally(() => (this.loading = false));
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1,
h2 {
  font-weight: normal;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
