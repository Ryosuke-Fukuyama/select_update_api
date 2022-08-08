<template>
  <div>
    <ul>
      <li v-for="property in propertyList" :key="property.id">
        {{ property.content }}
        <select v-model.lazy="selected" @change="contentUpdate(property.id, $event)">
          <option disabled value="">{{ property.content }}</option>
          <option value="content A">"content A"</option>
          <option value="content B">"content B"</option>
          <option value="content C">"content C"</option>
        </select>
        <div  v-if="modalFlag && missId==property.id">
          <Modal @close-click="closeModal"></Modal>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  data:() => {
    return {
      properties: [],
      id: '',
      uid: '',
      // selected: '',
      modalFlag: false,
      missId: '',
    }
  },

  mounted() {
    this.fetchContents()
  },

  computed: {
    propertyList: function() {
      return this.properties.sort(function (a, b) {
        if(a.created_at < b.created_at) return -1
        if(a.created_at > b.created_at) return 1
      return 0
    })
    },
  //   params() {
  //     return {
  //       property: {
  //         content: this.content,
  //         // id: this.id
  //       }
  //     }
  //   }
  },

  methods: {
    async fetchContents() {
      const res_index = await this.$axios.get('/api/v1/properties').then((res) => {
        this.properties = res.data.properties
        this.selected = ""
      })
    },

    async contentUpdate(id, $event) {
      const url = `/api/v1/properties/${id}`
      const res_data = await this.$axios.get(url)
      const patch_data = res_data.data.property
      patch_data.content = null
      this.$axios.patch(url, patch_data, { uid: this.uid })
        .then(res => {
          this.fetchContents()
        })
        .catch((err) => {
          const id = JSON.parse(err.config.data).id
          this.openModal(id)
        })
    },

    openModal(id) {
      this.modalFlag = true
      this.missId = id
    },
    closeModal(){
      this.modalFlag = false
      this.fetchContents()
    }
  }
}
</script>
