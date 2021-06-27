<template>
  <v-container fluid>
    <span v-for="(namespace, index) in namespaceList" v-bind:key="index">
      <h2>{{ namespace.name }} namespace</h2>
      <v-divider></v-divider>
      <span
        v-for="(ingress, index) in namespace.ingressList"
        v-bind:key="index"
      >
        <a>https://{{ ingress.host }}</a>
      </span>
    </span>
  </v-container>
</template>

<script>
import Vue from "vue";
import axios from "axios";

export default Vue.extend({
  name: "Home",
  data: () => ({
    namespaceList: [],
    ingressesList: [],
  }),
  async mounted() {
    try {
      const { data } = await axios.get("http://127.0.0.1:3000/api/namespaces");
      data.forEach(async (element) => {
        if (element.name != "") {
          const { data } = await axios.get(
            "http://127.0.0.1:3000/api/ingresses?namespace=" + element.name
          );

          this.namespaceList.push({ name: element.name, ingressList: data });
        }
      });
    } catch (error) {
      console.log(error);
    }
  },
});
</script>
