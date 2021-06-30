<template>
  <v-container fluid>
    <span v-for="(namespace, index) in namespaceList" v-bind:key="index">
      <h2>Namespace {{ namespace.name }}</h2>
      <v-divider></v-divider>
      <span
        v-for="(ingress, index) in namespace.ingressList"
        v-bind:key="index"
      >
        <v-row style="padding-left: 1em">
          <v-col cols="12">
            <a target="_blank" :href="`https://${ingress.host}`"
              >https://{{ ingress.host }}</a
            >
          </v-col>
        </v-row>
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
      const { data } = await axios.get(
        `${process.env.VUE_APP_BACKEND_HOSTNAME}/api/namespaces`
      );
      data.forEach(async (element) => {
        if (element.name != "") {
          const { data } = await axios.get(
            `${process.env.VUE_APP_BACKEND_HOSTNAME}/api/ingresses?namespace=${element.name}`
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
